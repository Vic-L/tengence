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
      expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
      expect(page).to have_content "NOTE: Resubscribing now will not charge immediately. The new billing cycle will start on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
      expect(page).to have_content 'Next Billing Date'
      expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
      expect(page).to have_link 'Resubscribe Now', href: subscribe_three_months_path
      expect(page).to have_link 'Resubscribe Now', href: subscribe_one_year_path
      expect(page).not_to have_selector '#unsubscribe'
      expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
    end

    scenario 'subscribe' do
      brain_tree_page.visit_subscribe_one_month_page
      expect(page.current_path).to eq subscribe_one_month_path

      brain_tree_page.visit_subscribe_three_months_page
      expect(page.current_path).to eq subscribe_three_months_path

      brain_tree_page.visit_subscribe_one_year_page
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

  end

  feature 'after/on next_billing_date' do

    scenario 'billing page' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_billing_page
        expect(page).not_to have_content 'Days left till end of Free Trial'
        expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
        expect(page).to have_content "NOTE: Resubscribing now will not charge immediately. The new billing cycle will start on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}."
        expect(page).not_to have_content 'Next Billing Date'
        expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
        expect(page).to have_link 'Resubscribe Now', href: subscribe_three_months_path
        expect(page).to have_link 'Resubscribe Now', href: subscribe_one_year_path
        expect(page).not_to have_selector '#unsubscribe'
        expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
      end
    end

    scenario 'subscribe' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_subscribe_one_month_page
      expect(page.current_path).to eq subscribe_one_month_path

      brain_tree_page.visit_subscribe_three_months_page
      expect(page.current_path).to eq subscribe_three_months_path

      brain_tree_page.visit_subscribe_one_year_page
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

  end

end