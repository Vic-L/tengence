require 'spec_helper'

feature "access pages by subscribed read_only users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:subscribed_user) {create(:user, :read_only, :subscribed_one_month)}

  feature 'access_pages' do

    before :each do
      login_as(subscribed_user, scope: :user)
    end

    scenario 'billing page' do
      brain_tree_page.visit_billing_page
      expect(page).not_to have_content 'Days left till end of Free Trial'
      expect(page).to have_content 'Plan:'
      expect(page).to have_content 'Next Billing Date:'
      expect(page).not_to have_content 'Valid Till:'
      expect(page).to have_content 'Card to charge:'
      expect(page).not_to have_content "Your subscription has ended."
      # expect(page).to have_link 'Pricing & Plans', href: plans_path
      expect(page).to have_link 'Unsubscribe', href: unsubscribe_path
      expect(page.current_path).to eq billing_path
    end

    scenario "billing" do
      brain_tree_page.visit_billing_page
      expect(page.current_path).to eq billing_path
    end

    # scenario "plans" do
    #   brain_tree_page.visit_plans_page
    #   expect(page).not_to have_link '30 days free trial', href: register_path
    #   expect(page).not_to have_content "Free"
    #   expect(page).not_to have_content "Your next billing date is on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}."
    #   expect(page).not_to have_content "Resubscribing now will not start immediately. It will start on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}."
    #   expect(page.current_path).to eq plans_path
    # end

    scenario "subscribe" do
      brain_tree_page.visit_subscribe_one_month_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence monthly ($59 / month)."
      expect(page).not_to have_content "You will be billed $59 immediately."
      expect(page).to have_content "You will NOT be billed $59 immediately."
      expect(page).to have_content "You have chosen to change to subscribe to Tengence monthly ($59 / month)."
      expect(page).to have_content "Your next billing date is on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).not_to have_content "You have chosen to resubscribe to Tengence monthly ($59 / month)."
      expect(page.current_path).to eq subscribe_one_month_path

      brain_tree_page.visit_subscribe_three_months_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence quarterly ($147 / 90 days)."
      expect(page).not_to have_content "You will be billed $147 immediately."
      expect(page).to have_content "You will NOT be billed $147 immediately."
      expect(page).to have_content "You have chosen to change to subscribe to Tengence quarterly ($147 / 90 days)."
      expect(page).to have_content "Your next billing date is on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).not_to have_content "You have chosen to resubscribe to Tengence quarterly ($147 / 90 days)."
      expect(page.current_path).to eq subscribe_three_months_path

      brain_tree_page.visit_subscribe_one_year_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence annually ($468 / year)."
      expect(page).not_to have_content "You will be billed $468 immediately."
      expect(page).to have_content "You will NOT be billed $468 immediately."
      expect(page).to have_content "You have chosen to change to subscribe to Tengence annually ($468 / year)."
      expect(page).to have_content "Your next billing date is on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).not_to have_content "You have chosen to resubscribe to Tengence annually ($468 / year)."
      expect(page.current_path).to eq subscribe_one_year_path
    end

    # scenario "change_payment" do
    #   brain_tree_page.visit_change_payment_page
    #   expect(page.current_path).to eq change_payment_path
    # end

    scenario "payment_history" do
      brain_tree_page.visit_payment_history_page
      expect(page.current_path).to eq payment_history_path
    end

    scenario "update_payment" do
      pending("how to do post in feature (non controller) spec")
      fail
    end

    scenario "toggle_renew" do
      pending("how to do post in feature (non controller) spec")
      fail
    end

  end

end