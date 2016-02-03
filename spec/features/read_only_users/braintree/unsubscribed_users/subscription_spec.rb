require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :read_only, :unsubscribed)}

  feature 'resubscribe' do

    before :each do
      login_as(unsubscribed_user, scope: :user)
      brain_tree_page.visit_billing_page
      wait_for_page_load
    end

    scenario 'should be able to resubscribe if next billing date has reached' do
      original_subscription_id = unsubscribed_user.braintree_subscription_id
      expect(unsubscribed_user.next_billing_date).not_to eq nil

      Timecop.freeze(unsubscribed_user.next_billing_date) do
        brain_tree_page.visit_billing_page
        wait_for_page_load
        expect(page).to have_selector '#subscribe'
        expect(page).not_to have_selector '#change-payment'
        expect(page).not_to have_selector '#unsubscribe'
        expect(page).not_to have_content "Resubscription is available from the next billing date"

        brain_tree_page.click_unique '#subscribe'
        wait_for_page_load
        expect(page).to have_selector 'iframe' # user same card
        page.within_frame 'braintree-dropin-frame' do
          expect(page).to have_selector '#choose-payment-method'
        end
        brain_tree_page.click_unique '#submit'
        wait_for_page_load
        expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'
        expect(page.current_path).to eq billing_path

        unsubscribed_user.reload

        expect(unsubscribed_user.braintree_subscription_id).not_to eq nil
        expect(unsubscribed_user.braintree_subscription_id).not_to eq original_subscription_id
        expect(unsubscribed_user.next_billing_date).to eq nil
        
        expect(page).not_to have_selector '#subscribe'
        expect(page).to have_selector '#change-payment'
        expect(page).to have_selector '#unsubscribe'
        expect(page).not_to have_content "Resubscription is available from the next billing date"
      end
    end

  end

end