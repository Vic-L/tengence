require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:subscribed_user) {create(:user, :subscribed_one_month)}

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
      fail
    end
  
  end

  feature 'upgrade' do

    before :each do
      login_as(subscribed_user, scope: :user)
      brain_tree_page.visit_billing_page
      wait_for_page_load
    end

    scenario 'should change plan' do

      expect(page).to have_content "Auto Renew?"
      expect(page).not_to have_content "Your subscription has ended."
      expect(page).not_to have_content "Resubscribing now will not charge immediately. The new billing cycle will start on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}"
      expect(page).to have_content "Upgrading now will not charge immediately. The new billing cycle will start on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}"
      expect(page).to have_link 'Upgrade Now', href: subscribe_one_month_path
      expect(page).to have_link 'Upgrade Now', href: subscribe_three_months_path
      expect(page).to have_link 'Upgrade Now', href: subscribe_one_year_path
      expect(page).to have_link 'Change Payment Settings', href: change_payment_path
      expect(page).to have_link 'Payment History', href: payment_history_path

      brain_tree_page.click_unique "#subscribe-quarterly"
      wait_for_page_load
      expect(page).to have_content "Subscription rate: $150 / 90 days"

      # first transaction that user unsubscribed from is not created
      expect(subscribed_user.subscribed_plan).to eq 'one_month_plan'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
      subscribed_user.reload
      expect(subscribed_user.subscribed_plan).to eq 'three_months_plan'

    end

    scenario 'should not charge' do

      expect(page).to have_content "Auto Renew?"
      expect(page).not_to have_content "Your subscription has ended."
      expect(page).not_to have_content "Resubscribing now will not charge immediately. The new billing cycle will start on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}"
      expect(page).to have_content "Upgrading now will not charge immediately. The new billing cycle will start on #{subscribed_user.next_billing_date.strftime('%e %b %Y')}"
      expect(page).to have_link 'Upgrade Now', href: subscribe_one_month_path
      expect(page).to have_link 'Upgrade Now', href: subscribe_three_months_path
      expect(page).to have_link 'Upgrade Now', href: subscribe_one_year_path
      expect(page).to have_link 'Change Payment Settings', href: change_payment_path
      expect(page).to have_link 'Payment History', href: payment_history_path

      brain_tree_page.click_unique "#subscribe-quarterly"
      wait_for_page_load
      expect(page).to have_content "Subscription rate: $150 / 90 days"

      # first transaction that user unsubscribed from is not created
      expect(subscribed_user.braintree.transactions.count).to eq 0
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
      subscribed_user.reload
      expect(subscribed_user.braintree.transactions.count).to eq 0

    end

  end

  feature 'unsubscribe' do

    before :each do
      login_as(subscribed_user, scope: :user)
      brain_tree_page.visit_billing_page
      wait_for_page_load
      expect(page).to have_content 'Billing Overview'
    end

    scenario 'should change subscribed_plan to free_plan' do
      expect(subscribed_user.subscribed_plan).to eq 'one_month_plan'
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.accept_confirm
      expect(page.current_path).to eq billing_path

      subscribed_user.reload
      expect(subscribed_user.subscribed_plan).to eq 'free_plan'
    end

    scenario 'should have nothing happen if never confirm to unsubscribe' do
      expect(subscribed_user.subscribed_plan).to eq 'one_month_plan'
      brain_tree_page.click_unique '#unsubscribe'
      brain_tree_page.reject_confirm
      sleep 1
      expect(page.current_path).to eq billing_path
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
