require 'spec_helper'

feature "access pages by read_only yet_to_subscribe users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:yet_to_subscribe_user) {create(:user, :braintree)}

  feature 'access_pages' do
    
    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
    end

    scenario 'billing page' do
      brain_tree_page.visit_billing_page
      expect(page).to have_content 'Days left till end of Free Trial'
      expect(page).to have_link 'Subscribe Now', href: subscribe_one_month_path
      expect(page).not_to have_content 'Next Billing Date'
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
      expect(page).to have_content 'You are not authorized to view this page.'
      expect(page.current_path).to eq billing_path
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
