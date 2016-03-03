require 'spec_helper'

feature "access pages by read_only resubscribe users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :read_only, :unsubscribed_one_month)}
  
  before :each do
    login_as(unsubscribed_user, scope: :user)
  end

  feature 'before next_billing_date' do

    scenario 'billing page' do
      brain_tree_page.visit_billing_page
      expect(page).not_to have_content 'Days left till end of Free Trial'
      expect(page).not_to have_content 'Auto Renew:'
      expect(page).not_to have_content 'Plan:'
      expect(page).to have_content 'Next Billing Date:'
      expect(page).not_to have_content 'Card to charge:'
      expect(page).not_to have_content "Your subscription has ended."
      expect(page).to have_link 'Pricing & Plans', href: plans_path
      expect(page).not_to have_link 'Unsubscribe', href: unsubscribe_path
      expect(page.current_path).to eq billing_path
    end

    scenario "plans" do
      brain_tree_page.visit_plans_page
      expect(page.current_path).to eq plans_path
    end

    scenario 'subscribe' do
      brain_tree_page.visit_subscribe_one_month_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence monthly ($60 / month)."
      expect(page).not_to have_content "You will be charged $60 immediately."
      expect(page).to have_content "You will NOT be charged $60 immediately."
      expect(page).not_to have_content "You have chosen to change to subscribe to Tengence monthly ($60 / month)."
      expect(page).to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).to have_content "You have chosen to resubscribe to Tengence monthly ($60 / month)."
      expect(page.current_path).to eq subscribe_one_month_path

      brain_tree_page.visit_subscribe_three_months_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence quarterly ($150 / 90 days)."
      expect(page).not_to have_content "You will be charged $150 immediately."
      expect(page).to have_content "You will NOT be charged $150 immediately."
      expect(page).not_to have_content "You have chosen to change to subscribe to Tengence quarterly ($150 / 90 days)."
      expect(page).to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).to have_content "You have chosen to resubscribe to Tengence quarterly ($150 / 90 days)."
      expect(page.current_path).to eq subscribe_three_months_path

      brain_tree_page.visit_subscribe_one_year_page
      expect(page).not_to have_content "You have chosen to subscribe to Tengence annually ($480 / year)."
      expect(page).not_to have_content "You will be charged $480 immediately."
      expect(page).to have_content "You will NOT be charged $480 immediately."
      expect(page).not_to have_content "You have chosen to change to subscribe to Tengence annually ($480 / year)."
      expect(page).to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).to have_content "You have chosen to resubscribe to Tengence annually ($480 / year)."
      expect(page.current_path).to eq subscribe_one_year_path
    end

    scenario 'change_payment' do
      brain_tree_page.visit_change_payment_page
      expect(page).to have_content 'You are not authorized to view this page.'
      expect(page.current_path).to eq billing_path
    end

    scenario "payment_history" do
      brain_tree_page.visit_payment_history_page
      expect(page.current_path).to eq payment_history_path
    end

    scenario "update_payment" do
      pending("how to do post in feature (non controller) spec")
      fail
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

  feature 'after/on next_billing_date' do

    scenario 'billing page' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_billing_page
        expect(page).not_to have_content 'Days left till end of Free Trial'
        expect(page).not_to have_content 'Auto Renew:'
        expect(page).not_to have_content 'Plan:'
        expect(page).not_to have_content 'Next Billing Date:'
        expect(page).not_to have_content 'Card to charge:'
        expect(page).to have_content "Your subscription has ended."
        expect(page).to have_link 'Pricing & Plans', href: plans_path
        expect(page).not_to have_link 'Unsubscribe', href: unsubscribe_path
        expect(page.current_path).to eq billing_path
      end
    end

    scenario "plans" do
      brain_tree_page.visit_plans_page
      expect(page.current_path).to eq plans_path
    end

    scenario 'subscribe' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_subscribe_one_month_page
        expect(page).not_to have_content "You have chosen to subscribe to Tengence monthly ($60 / month)."
        expect(page).to have_content "You will be charged $60 immediately."
        expect(page).not_to have_content "You will NOT be charged $60 immediately."
        expect(page).not_to have_content "You have chosen to change to subscribe to Tengence monthly ($60 / month)."
        expect(page).not_to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
        expect(page).to have_content "You have chosen to resubscribe to Tengence monthly ($60 / month)."
        expect(page.current_path).to eq subscribe_one_month_path

        brain_tree_page.visit_subscribe_three_months_page
        expect(page).not_to have_content "You have chosen to subscribe to Tengence quarterly ($150 / 90 days)."
        expect(page).to have_content "You will be charged $150 immediately."
        expect(page).not_to have_content "You will NOT be charged $150 immediately."
        expect(page).not_to have_content "You have chosen to change to subscribe to Tengence quarterly ($150 / 90 days)."
        expect(page).not_to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
        expect(page).to have_content "You have chosen to resubscribe to Tengence quarterly ($150 / 90 days)."
        expect(page.current_path).to eq subscribe_three_months_path

        brain_tree_page.visit_subscribe_one_year_page
        expect(page).not_to have_content "You have chosen to subscribe to Tengence annually ($480 / year)."
        expect(page).to have_content "You will be charged $480 immediately."
        expect(page).not_to have_content "You will NOT be charged $480 immediately."
        expect(page).not_to have_content "You have chosen to change to subscribe to Tengence annually ($480 / year)."
        expect(page).not_to have_content "Your next billing date is on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
        expect(page).to have_content "You have chosen to resubscribe to Tengence annually ($480 / year)."
        expect(page.current_path).to eq subscribe_one_year_path
      end
    end

    scenario 'change_payment' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_change_payment_page
        expect(page.current_path).to eq billing_path
      end
    end

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