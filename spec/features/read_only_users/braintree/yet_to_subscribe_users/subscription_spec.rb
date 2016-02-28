require 'spec_helper'

feature 'subscription', type: :feature, js: true do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:yet_to_subscribe_user) {create(:user, :braintree)}

  feature 'validations' do
    
    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
      brain_tree_page.visit_subscribe_one_month_page
      wait_for_page_load
    end
    
    scenario 'with nothing filled in' do
      expect(page).to have_selector 'iframe'
      brain_tree_page.click_unique '#submit'
      page.within_frame 'braintree-dropin-frame' do
        expect(page).to have_css('.credit-card-number-label.invalid')
        expect(page).to have_css('.expiration-label.invalid')
        expect(page).to have_css('.cvv-label.invalid')
      end
      expect(page.current_path).to eq subscribe_one_month_path
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
      
      expect(page.current_path).to eq subscribe_one_month_path
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

      expect(page.current_path).to eq subscribe_one_month_path
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

      expect(page.current_path).to eq subscribe_one_month_path
      expect(page).to have_content 'Error!'
    end

    scenario 'with fully filled valid fields' do

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq nil
      expect(yet_to_subscribe_user.default_payment_method_token).to eq nil

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
      expect(page).not_to have_link 'Subscribe Now', href: subscribe_one_month_path
      expect(page).to have_content 'Next Billing Date'
      expect(page).to have_link 'Change Payment Settings', href: change_payment_path
      
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).not_to eq nil
      expect(yet_to_subscribe_user.default_payment_method_token).not_to eq nil

    end

  end

  feature 'subscribe to the correct plan' do

    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
    end

    scenario 'one_month_plan' do
      brain_tree_page.visit_subscribe_one_month_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq Date.today + 30.day
      expect(yet_to_subscribe_user.default_payment_method_token).not_to eq nil
      expect(yet_to_subscribe_user.subscribed_plan).to eq 'one_month_plan'

    end

    scenario 'three_months_plan' do
      brain_tree_page.visit_subscribe_three_months_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq Date.today + 90.day
      expect(yet_to_subscribe_user.default_payment_method_token).not_to eq nil
      expect(yet_to_subscribe_user.subscribed_plan).to eq 'three_months_plan'
    end

    scenario 'one_year_plan' do
      brain_tree_page.visit_subscribe_one_year_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq Date.today + 1.year
      expect(yet_to_subscribe_user.default_payment_method_token).not_to eq nil
      expect(yet_to_subscribe_user.subscribed_plan).to eq 'one_year_plan'

    end

  end

  feature 'auto renew' do

    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
    end

    scenario 'should change to true if checked' do
      brain_tree_page.visit_subscribe_one_year_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      check("renew")
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      expect(yet_to_subscribe_user.auto_renew).to eq false
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.auto_renew).to eq true
    end

    scenario 'should change to false if checked' do
      brain_tree_page.visit_subscribe_one_year_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      uncheck("renew")
      
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      expect(yet_to_subscribe_user.auto_renew).to eq false
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.auto_renew).to eq false
    end

    scenario 'toggle in billing path' do
      expect(page).not_to have_content "Auto Renew?"
    end

  end

end
