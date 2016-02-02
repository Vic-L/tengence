require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:unsubscribed_user) {create(:user, :read_only, :braintree)}
  let!(:subscribed_user) {create(:user, :read_only, :subscribed)}

  feature 'unsubscribed user' do

    before :each do
      login_as(unsubscribed_user, scope: :user)
      brain_tree_page.visit_subscribe_page
      wait_for_page_load
    end

    feature 'validations' do
      
      scenario 'with nothing filled in' do
        expect(page).to have_selector 'iframe'
        brain_tree_page.click_unique '#submit'
        page.within_frame 'braintree-dropin-frame' do
          expect(page).to have_css('.credit-card-number-label.invalid')
          expect(page).to have_css('.expiration-label.invalid')
          expect(page).to have_css('.cvv-label.invalid')
        end
        expect(page.current_path).to eq subscribe_path
      end

      scenario 'with unmatched cvv' do        
        expect(page).to have_selector 'iframe'
        page.within_frame 'braintree-dropin-frame' do
          fill_in 'credit-card-number', with: brain_tree_page.valid_visa
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.unmatched_cvv
        end
        
        brain_tree_page.click_unique '#submit'
        wait_for_page_load
        
        expect(page.current_path).to eq subscribe_path
        expect(page).to have_content 'Error!'

        # NOTE: the tests below should happen under human interaction
        # page.within_frame 'braintree-dropin-frame' do
        #   expect(page).to have_content 'There was an error processing your request.'
        # end
      end

      scenario 'with unverified cvv' do
        expect(page).to have_selector 'iframe'
        page.within_frame 'braintree-dropin-frame' do
          fill_in 'credit-card-number', with: brain_tree_page.valid_visa
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.unverified_cvv
        end
        
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page.current_path).to eq subscribe_path
        expect(page).to have_content 'Error!'
      end

      scenario 'with invalid card' do
        expect(page).to have_selector 'iframe'
        page.within_frame 'braintree-dropin-frame' do
          fill_in 'credit-card-number', with: brain_tree_page.invalid_visa
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.valid_cvv
        end
        
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page.current_path).to eq subscribe_path
        expect(page).to have_content 'Error!'
      end

      scenario 'with fully filled valid fields' do

        expect(unsubscribed_user.reload.braintree_subscription_id).to eq nil
        expect(unsubscribed_user.reload.default_payment_method_token).to eq nil
        brain_tree_page.click_unique '#submit'
        expect(page).to have_selector 'iframe'
        page.within_frame 'braintree-dropin-frame' do
          fill_in 'credit-card-number', with: brain_tree_page.valid_visa
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.valid_cvv
        end
        sleep 0.5
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page.current_path).to eq billing_path
        expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'
        
        expect(page).not_to have_content 'Days left till end of Free Trial'
        expect(page).not_to have_link 'Subscribe Now', href: subscribe_path
        expect(page).to have_content 'Next Billing Date'
        expect(page).to have_link 'Change Payment Settings', href: change_payment_path
        
        expect(unsubscribed_user.reload.braintree_subscription_id).not_to eq nil
        expect(unsubscribed_user.reload.default_payment_method_token).not_to eq nil

      end

    end

    scenario 'should have correct contents in page' do
      expect(page).to have_content 'Days left till end of Free Trial'
      expect(page).to have_link 'Subscribe Now', href: subscribe_path
      expect(page).not_to have_content 'Next Billing Date'
      expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
    end

  end

  feature 'subscribed user' do

    feature 'change payment' do
      before :each do
        login_as(subscribed_user, scope: :user)
        brain_tree_page.visit_subscribe_page
        wait_for_page_load
      end

      scenario 'with a different card' do
        brain_tree_page.click_unique '#change-payment'
        wait_for_page_load

        expect(page).to have_selector 'iframe'
        page.within_frame 'braintree-dropin-frame' do
          brain_tree_page.click_unique '#choose-payment-method'
        end
        
        expect(page).to have_selector '#braintree-dropin-modal-frame'
        page.within_frame 'braintree-dropin-modal-frame' do
          brain_tree_page.click_common '.add-payment-method-link'
          sleep 1
          fill_in 'credit-card-number', with: brain_tree_page.valid_mastercard
          fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
          fill_in 'cvv', with: brain_tree_page.valid_cvv
          brain_tree_page.click_unique '.payment-method-add'
        end
        wait_for_ajax
        
        brain_tree_page.click_unique '#submit'
        wait_for_page_load

        expect(page).to have_content 'You have successfully change your default payment method'
        expect(page.current_path).to eq billing_path
      end

      pending 'with the same card' do
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

    feature 'resubscribe' do
      before :each do
        login_as(subscribed_user, scope: :user)
        brain_tree_page.visit_billing_page
        wait_for_page_load
        brain_tree_page.click_unique '#unsubscribe'
        brain_tree_page.accept_confirm
        expect(page).to have_content 'You have successfully unsubscribed from Tengence.'
        subscribed_user.reload
      end

      scenario 'should not be able to resubscribe if next billing date has not reached' do
        expect(page).not_to have_selector '#subscribe'
        expect(page).not_to have_selector '#change-payment'
        expect(page).not_to have_selector '#unsubscribe'
        expect(page).to have_content "Reubscription is available from the next billing date, #{Date.parse(subscribed_user.braintree_subscription.next_billing_date).strftime('%e %b %Y')}, onwards."
        
        Timecop.freeze(subscribed_user.next_billing_date - 1.day)
        brain_tree_page.visit_billing_page
        wait_for_page_load
        expect(page).not_to have_selector '#subscribe'
        expect(page).not_to have_selector '#change-payment'
        expect(page).not_to have_selector '#unsubscribe'
        expect(page).to have_content "Reubscription is available from the next billing date, #{Date.parse(subscribed_user.braintree_subscription.next_billing_date).strftime('%e %b %Y')}, onwards."
      end

      scenario 'should be able to resubscribe if next billing date has reached with the ' do
        original_subscription_id = subscribed_user.braintree_subscription_id
        expect(subscribed_user.next_billing_date).not_to eq nil

        Timecop.freeze(subscribed_user.next_billing_date)
        brain_tree_page.visit_billing_page
        wait_for_page_load
        expect(page).to have_selector '#subscribe'
        expect(page).not_to have_selector '#change-payment'
        expect(page).not_to have_selector '#unsubscribe'
        expect(page).not_to have_content "Reubscription is available from the next billing date"

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

        subscribed_user.reload

        expect(subscribed_user.braintree_subscription_id).not_to eq original_subscription_id
        expect(subscribed_user.next_billing_date).to eq nil
        expect(page).not_to have_selector '#subscribe'
        expect(page).to have_selector '#change-payment'
        expect(page).to have_selector '#unsubscribe'
        expect(page).not_to have_content "Reubscription is available from the next billing date"
      end

    end

  end

end