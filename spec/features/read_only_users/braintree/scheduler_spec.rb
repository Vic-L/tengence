require 'spec_helper'

feature 'scheduler' do
  let!(:unsubscribed_user) {create(:user, :unsubscribed_one_month)}
  let!(:subscribed_one_month_user) {create(:user, :subscribed_one_month)}
  let!(:subscribed_three_months_user) {create(:user, :subscribed_three_months)}
  let!(:yet_to_subscribe_user) {create(:user, :braintree)}

  before :each do
    Tengence::Application.load_tasks
  end

  feature "charge_users" do

    scenario "should not charge the subscribed user if user's next_billing_date is not today" do
      
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
      expect(subscribed_three_months_user.braintree.transactions.count).to eq 0

      Rake::Task['maintenance:charge_users'].reenable
      Rake::Task['maintenance:charge_users'].invoke

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
      expect(subscribed_three_months_user.braintree.transactions.count).to eq 0
    end

    scenario "should charge the subscribed user if user's next_billing_date is today" do
      subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0

      Rake::Task['maintenance:charge_users'].reenable
      Rake::Task['maintenance:charge_users'].invoke

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 1
    end

    scenario "should not charge unsubscribed_user" do
      expect(unsubscribed_user.braintree.transactions.count).to eq 0

      Rake::Task['maintenance:charge_users'].reenable
      Rake::Task['maintenance:charge_users'].invoke

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
    end

    scenario 'should change next_billing_date of users correctly' do
      subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
      subscribed_one_month_user_initial_next_billing_date = subscribed_one_month_user.next_billing_date
      subscribed_three_months_user_initial_next_billing_date = subscribed_three_months_user.next_billing_date

      Rake::Task['maintenance:charge_users'].reenable
      Rake::Task['maintenance:charge_users'].invoke

      subscribed_one_month_user.reload
      subscribed_three_months_user.reload
      expect(subscribed_one_month_user.next_billing_date).to eq subscribed_one_month_user_initial_next_billing_date + 30.days
      expect(subscribed_three_months_user.next_billing_date).to eq subscribed_three_months_user_initial_next_billing_date

      subscribed_three_months_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
      subscribed_one_month_user_initial_next_billing_date = subscribed_one_month_user.next_billing_date
      subscribed_three_months_user_initial_next_billing_date = subscribed_three_months_user.next_billing_date

      Rake::Task['maintenance:charge_users'].reenable
      Rake::Task['maintenance:charge_users'].invoke

      subscribed_one_month_user.reload
      subscribed_three_months_user.reload
      expect(subscribed_one_month_user.next_billing_date).to eq subscribed_one_month_user_initial_next_billing_date
      expect(subscribed_three_months_user.next_billing_date).to eq subscribed_three_months_user_initial_next_billing_date + 90.days
    end

  end

  feature "subscription_ending_reminder" do

    scenario 'should not send to users with next_billing_date not 7 days later' do
      ActionMailer::Base.deliveries.clear
      Rake::Task['maintenance:subscription_ending_reminder'].reenable
      Rake::Task['maintenance:subscription_ending_reminder'].invoke
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end

    scenario 'should send to users with next_billing_date in 7 days time' do
      Timecop.freeze(subscribed_one_month_user.next_billing_date - 7.days) do
        ActionMailer::Base.deliveries.clear
        Rake::Task['maintenance:subscription_ending_reminder'].reenable
        Rake::Task['maintenance:subscription_ending_reminder'].invoke
# binding.pry if ActionMailer::Base.deliveries.count == 12 # wonder y
        expect(ActionMailer::Base.deliveries.count).to eq 2 # InternalMailer and AlertsMailer
        expect(ActionMailer::Base.deliveries.map(&:subject).include?("Subscription ending in 7 days")).to eq true
        expect(ActionMailer::Base.deliveries.map(&:subject).include?("#{subscribed_one_month_user.email} subscription ending in 7 days time")).to eq true
      end
    end

    scenario 'should give different texts for auto_renew on and off users' do
      Timecop.freeze(subscribed_one_month_user.next_billing_date - 7.days) do
        
        subscribed_one_month_user.update(auto_renew: true)
        ActionMailer::Base.deliveries.clear
        Rake::Task['maintenance:subscription_ending_reminder'].reenable
        Rake::Task['maintenance:subscription_ending_reminder'].invoke

        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "You have chosen to auto renew your subscription monthly ($59 / month).").to eq true
        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "No action is required on your part.").to eq true

        subscribed_one_month_user.update(auto_renew: false)
        ActionMailer::Base.deliveries.clear
        Rake::Task['maintenance:subscription_ending_reminder'].reenable
        Rake::Task['maintenance:subscription_ending_reminder'].invoke

        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "You have chosen to NOT auto renew your subscription monthly ($59 / month).").to eq true
        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "No action is required on your part.").to eq false

        # TODO check the no auto renew text
      end
    end

  end

end