require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:subscribed_user) {create(:user, :read_only, :subscribed_one_month)}

  feature 'change payment' do
    before :each do
      login_as(subscribed_user, scope: :user)
      brain_tree_page.visit_change_payment_page
      wait_for_page_load
    end

    scenario 'with a different card' do
      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        brain_tree_page.click_unique '#choose-payment-method'
      end
      
      expect(page).to have_selector '#braintree-dropin-modal-frame'
      page.within_frame 'braintree-dropin-modal-frame' do
        expect(page).to have_selector '.add-payment-method-link'
        brain_tree_page.click_common '.add-payment-method-link'
        
        expect(page).to have_selector '#credit-card-number'
        fill_in 'credit-card-number', with: brain_tree_page.valid_mastercard
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
        brain_tree_page.click_unique '.payment-method-add'
        wait_for_ajax
        sleep 1
      end
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully changed your default payment method'
      expect(page.current_path).to eq billing_path
    end

    pending 'with the same card' do
      expect('no change in default payment method')
    end
  
  end

  feature 'unsubscribe' do

    before :each do
      login_as(subscribed_user, scope: :user)
      brain_tree_page.visit_billing_page
      wait_for_page_load
      expect(page).to have_content 'Billing Overview'
    end

    scenario 'should change subscription status to cancelled' do
      expect(subscribed_user.braintree_subscription.status).to eq 'Active'
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.reject_confirm
      sleep 1
      expect(page.current_path).to eq billing_path
    end

    scenario 'should change subscription status to cancelled' do
      expect(subscribed_user.braintree_subscription.status).to eq 'Active'
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.accept_confirm
      wait_for_page_load
      expect(subscribed_user.braintree_subscription.status).to eq 'Canceled'
    end

    scenario 'should populate next_billing_date column of users' do
      expect(subscribed_user.reload.next_billing_date).to eq nil
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.accept_confirm
      wait_for_page_load
      expect(subscribed_user.reload.next_billing_date).not_to eq nil
    end

    scenario 'should redirect to billing_path' do
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.accept_confirm
      wait_for_page_load
      expect(page).to have_content 'You have successfully unsubscribed from Tengence.'
      expect(page.current_path).to eq billing_path
    end

  end

end
