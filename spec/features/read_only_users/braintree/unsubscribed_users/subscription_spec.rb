require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :unsubscribed_one_month)}

  feature 'resubscribe' do

    before :each do
      login_as(unsubscribed_user, scope: :user)
      brain_tree_page.visit_plans_page
      wait_for_page_load
    end

    scenario 'should not be billed if resubscribed before next billing date' do
      brain_tree_page.click_unique "#subscribe-quarterly"
      wait_for_page_load

      expect(page).to have_selector '#braintree-dropin-frame'

      # first transaction that user unsubscribed from is not created
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
      unsubscribed_user.reload
      expect(unsubscribed_user.braintree.transactions.count).to eq 0
    end

    scenario 'should be billed if resubscribed after next billing date' do

      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.click_unique "#subscribe-quarterly"

        expect(page).to have_selector '#braintree-dropin-frame'

        # first transaction that user unsubscribed from is not created
        expect(unsubscribed_user.braintree.transactions.count).to eq 0
        brain_tree_page.scroll_into_view '#submit'
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page).to have_content "Congratulations, you have successfully subscribed to Tengence. Welcome to the community!\nAn invoice of this transaction will be sent to your registered email shortly."
        unsubscribed_user.reload
        expect(unsubscribed_user.braintree.transactions.count).to eq 1
      end

    end

    scenario 'toggle in billing path' do
      expect(page).not_to have_content "Auto Renew?"
    end

  end

end