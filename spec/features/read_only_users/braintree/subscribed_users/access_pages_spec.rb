require 'spec_helper'

feature "access pages by subscribed read_only users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:subscribed_user) {create(:user, :read_only, :subscribed)}

  feature 'billing page' do
    
    before :each do
      login_as(subscribed_user, scope: :user)
    end

    scenario 'should have correct contents in page' do
      brain_tree_page.visit_billing_page
      expect(page).not_to have_content 'Days left till end of Free Trial'
      expect(page).not_to have_link 'Subscribe Now', href: subscribe_path
      expect(page).to have_content 'Next Billing Date'
      expect(page).to have_link 'Change Payment Settings', href: change_payment_path
    end

    scenario 'subscribe' do
      brain_tree_page.visit_subscribe_page
      expect(page).to have_content 'You are not authorized to view this page.'
      expect(page.current_path).to eq billing_path
    end

    scenario 'change_payment' do
      brain_tree_page.visit_change_payment_page
      expect(page.current_path).to eq change_payment_path
    end

  end

end