require 'spec_helper'

feature 'scheduler' do
  let!(:unsubscribed_user) {create(:user, :unsubscribed_one_month, :auto_renew)}
  let!(:subscribed_one_month_user) {create(:user, :subscribed_one_month, :auto_renew)}
  let!(:subscribed_three_months_user) {create(:user, :subscribed_three_months, :auto_renew)}
  let!(:yet_to_subscribe_user) {create(:user, :braintree, :auto_renew)}

  before :all do
    Tengence::Application.load_tasks
  end

  let :rake_subscription_ending_reminder do
    Rake::Task['maintenance:subscription_ending_reminder'].reenable
    Rake::Task['maintenance:subscription_ending_reminder'].invoke
  end

  let :rake_charge_users do
    Rake::Task['maintenance:charge_users'].reenable
    Rake::Task['maintenance:charge_users'].invoke
  end

  feature "charge_users" do

    scenario "should not charge the subscribed user if user's next_billing_date is not today" do
      
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
      expect(subscribed_three_months_user.braintree.transactions.count).to eq 0

      rake_charge_users

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
      expect(subscribed_three_months_user.braintree.transactions.count).to eq 0
    end

    scenario "should charge the subscribed user if user's next_billing_date is today" do
      subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0

      rake_charge_users

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 1
    end

    scenario "should not charge unsubscribed_user" do
      expect(unsubscribed_user.braintree.transactions.count).to eq 0

      rake_charge_users

      # NOTE: DONT subscribed_one_month_user.reload as it will change braintree_customer_id
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
    end

    feature 'should change next_billing_date of users correctly' do

      let!(:subscribed_one_year_user) {create(:user, :subscribed_one_year, :auto_renew)}

      scenario 'for one_month_user' do
        subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
        subscribed_one_month_user_initial_next_billing_date = subscribed_one_month_user.next_billing_date
        subscribed_three_months_user_initial_next_billing_date = subscribed_three_months_user.next_billing_date
        subscribed_one_year_user_initial_next_billing_date = subscribed_one_year_user.next_billing_date

        rake_charge_users

        subscribed_one_month_user.reload
        subscribed_three_months_user.reload
        subscribed_one_year_user.reload

        expect(subscribed_one_month_user.next_billing_date).to eq subscribed_one_month_user_initial_next_billing_date + 30.days
        expect(subscribed_three_months_user.next_billing_date).to eq subscribed_three_months_user_initial_next_billing_date
        expect(subscribed_one_year_user.next_billing_date).to eq subscribed_one_year_user_initial_next_billing_date
      end

      scenario 'for three_months user' do
        subscribed_three_months_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
        subscribed_one_month_user_initial_next_billing_date = subscribed_one_month_user.next_billing_date
        subscribed_three_months_user_initial_next_billing_date = subscribed_three_months_user.next_billing_date
        subscribed_one_year_user_initial_next_billing_date = subscribed_one_year_user.next_billing_date

        rake_charge_users

        subscribed_one_month_user.reload
        subscribed_three_months_user.reload
        subscribed_one_year_user.reload

        expect(subscribed_one_month_user.next_billing_date).to eq subscribed_one_month_user_initial_next_billing_date
        expect(subscribed_three_months_user.next_billing_date).to eq subscribed_three_months_user_initial_next_billing_date + 90.days
        expect(subscribed_one_year_user.next_billing_date).to eq subscribed_one_year_user_initial_next_billing_date
      end

      scenario 'for one_year user' do
        subscribed_one_year_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date)
        subscribed_one_month_user_initial_next_billing_date = subscribed_one_month_user.next_billing_date
        subscribed_three_months_user_initial_next_billing_date = subscribed_three_months_user.next_billing_date
        subscribed_one_year_user_initial_next_billing_date = subscribed_one_year_user.next_billing_date

        rake_charge_users

        subscribed_one_month_user.reload
        subscribed_three_months_user.reload
        subscribed_one_year_user.reload

        expect(subscribed_one_month_user.next_billing_date).to eq subscribed_one_month_user_initial_next_billing_date
        expect(subscribed_three_months_user.next_billing_date).to eq subscribed_three_months_user_initial_next_billing_date
        expect(subscribed_one_year_user.next_billing_date).to eq subscribed_one_year_user_initial_next_billing_date + 1.year
      end

    end

    scenario 'should downgrade subscribed_user plan n become unsubscribed if not auto_renew' do
      subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date, auto_renew: false)

      rake_charge_users

      subscribed_one_month_user.reload
      expect(subscribed_one_month_user.subscribed_plan).to eq 'free_plan'
      expect(subscribed_one_month_user.unsubscribed_and_finished_cycle?).to eq true
    end

    scenario 'should not charge user if not auto_renew' do
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
      subscribed_one_month_user.update(next_billing_date: Time.now.in_time_zone('Singapore').to_date, auto_renew: false)
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0

      rake_charge_users

      subscribed_one_month_user.reload
      expect(subscribed_one_month_user.braintree.transactions.count).to eq 0
    end

  end

  feature "subscription_ending_reminder" do

    scenario 'should not send to users with next_billing_date not 7 days later' do
      ActionMailer::Base.deliveries.clear
      
      rake_subscription_ending_reminder

      expect(ActionMailer::Base.deliveries.count).to eq 0
    end

    scenario 'should send to users with next_billing_date in 7 days time' do
      Timecop.freeze(subscribed_one_month_user.next_billing_date - 7.days) do
        ActionMailer::Base.deliveries.clear
        
        rake_subscription_ending_reminder

        expect(ActionMailer::Base.deliveries.count).to eq 2 # InternalMailer and AlertsMailer
        expect(ActionMailer::Base.deliveries.map(&:subject).include?("Subscription ending in 7 days")).to eq true
        expect(ActionMailer::Base.deliveries.map(&:subject).include?("#{subscribed_one_month_user.email} subscription ending in 7 days time")).to eq true
      end
    end

    scenario 'should give specific texts for auto_renew on users' do
      Timecop.freeze(subscribed_one_month_user.next_billing_date - 7.days) do
        
        ActionMailer::Base.deliveries.clear
        
        rake_subscription_ending_reminder

        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "You have chosen to auto renew your subscription monthly ($59 / month).").to eq true
        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "No action is required on your part.").to eq true
      end
    end

    scenario 'should give specific texts for auto_renew on users' do
      Timecop.freeze(subscribed_one_month_user.next_billing_date - 7.days) do
        
        subscribed_one_month_user.update(auto_renew: false)
        subscribed_one_month_user.reload

        ActionMailer::Base.deliveries.clear
        rake_subscription_ending_reminder

        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "You have chosen to NOT auto renew your subscription monthly ($59 / month).").to eq true
        expect(ActionMailer::Base.deliveries.last.body.raw_source.include? "No action is required on your part.").to eq false
      end
    end

  end

end