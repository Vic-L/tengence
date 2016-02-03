require 'spec_helper'

feature "access pages by read_only resubscribe users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :read_only, :unsubscribed)}
  
  before :each do
    login_as(unsubscribed_user, scope: :user)
  end

  feature 'before next_billing_date' do

    scenario 'billing page' do
      brain_tree_page.visit_billing_page
      expect(page).not_to have_content 'Days left till end of Free Trial'
      expect(page).not_to have_link 'Subscribe Now', href: subscribe_path
      expect(page).to have_content "Resubscription is available from the next billing date, #{Date.parse(unsubscribed_user.braintree_subscription.next_billing_date).strftime('%e %b %Y')}, onwards."
      expect(page).to have_content 'Next Billing Date'
      expect(page).not_to have_selector '#subscribe'
      expect(page).not_to have_selector '#change-payment'
      expect(page).not_to have_selector '#unsubscribe'
      expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
    end

    scenario 'subscribe' do
      brain_tree_page.visit_subscribe_page
      expect(page).to have_content 'You are not authorized to view this page.'
      expect(page.current_path).to eq billing_path
    end

    scenario 'change_payment' do
      brain_tree_page.visit_change_payment_page
      expect(page).to have_content 'You are not authorized to view this page.'
      expect(page.current_path).to eq billing_path
    end

  end

  feature 'after/on next_billing_date' do

    scenario 'billing page' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_billing_page
        expect(page).not_to have_content 'Days left till end of Free Trial'
        expect(page).to have_link 'Subscribe Now', href: subscribe_path
        expect(page).not_to have_content "Resubscription is available from the next billing date, #{Date.parse(unsubscribed_user.braintree_subscription.next_billing_date).strftime('%e %b %Y')}, onwards."
        expect(page).not_to have_content 'Next Billing Date'
        expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
      end
    end

    scenario 'subscribe' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_subscribe_page
        expect(page.current_path).to eq subscribe_path
      end
    end

    scenario 'change_payment' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_change_payment_page
        expect(page.current_path).to eq change_payment_path
      end
    end

  end

end