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
      brain_tree_page.scroll_into_view '#submit'
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
      
      brain_tree_page.scroll_into_view '#submit'
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
      
      brain_tree_page.scroll_into_view '#submit'
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
      
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page.current_path).to eq subscribe_one_month_path
      expect(page).to have_content 'Error!'
    end

    scenario 'with fully filled valid fields' do

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq nil
      expect(yet_to_subscribe_user.default_payment_method_token).to eq nil

      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      sleep 0.5
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page.current_path).to eq billing_path
      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'
      
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
      
      brain_tree_page.scroll_into_view '#submit'
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
      
      brain_tree_page.scroll_into_view '#submit'
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
      
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.next_billing_date).to eq Date.today + 1.year
      expect(yet_to_subscribe_user.default_payment_method_token).not_to eq nil
      expect(yet_to_subscribe_user.subscribed_plan).to eq 'one_year_plan'

    end

  end

  feature "transactions" do

    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
      brain_tree_page.visit_subscribe_three_months_page
    end

    scenario 'should charge' do

      expect(page).to have_selector 'iframe'
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.braintree.transactions.count).to eq 0
      
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content "You have successfully subscribed to Tengence. Welcome to the community."
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.braintree.transactions.count).to eq 1

    end

  end

  feature 'auto renew' do

    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
    end

    scenario 'should remain false if not toggle to true' do
      brain_tree_page.visit_subscribe_one_year_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      expect(page).to have_content "You will be charged $468 immediately."
      expect(page).to have_content "You will NOT be automatically charged $468 on your next billing date on #{(Date.today + 1.year).strftime('%e %b %Y')}."
      
      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      expect(yet_to_subscribe_user.auto_renew).to eq false
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.auto_renew).to eq false
    end

    scenario 'should be true if toggle to true' do
      brain_tree_page.visit_subscribe_one_year_page
      wait_for_page_load

      expect(page).to have_selector 'iframe'
      page.within_frame 'braintree-dropin-frame' do
        fill_in 'credit-card-number', with: brain_tree_page.valid_visa
        fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
        fill_in 'cvv', with: brain_tree_page.valid_cvv
      end
      expect(page).to have_content "You will be charged $468 immediately."
      expect(page).to have_content "You will NOT be automatically charged $468 on your next billing date on #{(Date.today + 1.year).strftime('%e %b %Y')}."

      brain_tree_page.scroll_into_view '#renewal-toggle'
      brain_tree_page.click_unique '#renewal-toggle'

      expect(page).to have_content "You will be charged $468 immediately."
      expect(page).to have_content "You will be automatically charged $468 on your next billing date on #{(Date.today + 1.year).strftime('%e %b %Y')}."

      brain_tree_page.scroll_into_view '#submit'
      brain_tree_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You have successfully subscribed to Tengence. Welcome to the community.'

      expect(yet_to_subscribe_user.auto_renew).to eq false
      yet_to_subscribe_user.reload
      expect(yet_to_subscribe_user.auto_renew).to eq true
    end

    scenario 'toggle in billing path' do
      expect(page).not_to have_content "Auto Renew?"
    end

  end

end
