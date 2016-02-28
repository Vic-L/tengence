require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :braintree, :unsubscribed_one_month)}

  feature 'resubscribe' do

    before :each do
      login_as(unsubscribed_user, scope: :user)
      brain_tree_page.visit_billing_page
      wait_for_page_load
    end

    scenario 'should not be charged if resubscribed before next billing date' do
      expect(page).not_to have_content "Auto Renew?"
      expect(page).not_to have_content "Your subscription has ended."
      expect(page).to have_content "Resubscribing now will not charge immediately. The new billing cycle will start on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}"
      expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
      expect(page).to have_link 'Resubscribe Now', href: subscribe_three_months_path
      expect(page).to have_link 'Resubscribe Now', href: subscribe_one_year_path
      expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
      expect(page).to have_link 'Payment History', href: payment_history_path

      brain_tree_page.click_unique "#subscribe-quarterly"
      expect(page).to have_content "Subscription rate: $150 / 90 days"

      # no card details as payment method is abstractly created
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end

      # first transaction that user unsubscribed from is not created
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
      unsubscribed_user.reload
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
    end

    scenario 'should be charged if resubscribed after next billing date' do

      Timecop.freeze(unsubscribed_user.next_billing_date) do
        expect(page).not_to have_content "Auto Renew?"
        expect(page).not_to have_content "Your subscription has ended."
        expect(page).to have_content "Resubscribing now will not charge immediately. The new billing cycle will start on #{unsubscribed_user.next_billing_date.strftime('%e %b %Y')}"
        expect(page).to have_link 'Resubscribe Now', href: subscribe_one_month_path
        expect(page).to have_link 'Resubscribe Now', href: subscribe_three_months_path
        expect(page).to have_link 'Resubscribe Now', href: subscribe_one_year_path
        expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
        expect(page).to have_link 'Payment History', href: payment_history_path

        brain_tree_page.click_unique "#subscribe-quarterly"
        expect(page).to have_content "Subscription rate: $150 / 90 days"

        # no card details as payment method is abstractly created
        page.within_frame 'braintree-dropin-frame' do
          fill_in 'credit-card-number', with: brain_tree_page.valid_visa
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.valid_cvv
        end

        # first transaction that user unsubscribed from is not created
        expect(unsubscribed_user.braintree.transactions.count).to eq 0
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
        unsubscribed_user.reload
        expect(unsubscribed_user.braintree.transactions.count).to eq 1
      end

    end

  end

end