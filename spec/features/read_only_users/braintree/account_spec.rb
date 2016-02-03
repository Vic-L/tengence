require 'spec_helper'

feature 'account', type: :feature, js: :true do
  let(:devise_page) { DevisePage.new }
  let!(:subscribed_user) { create(:user, :subscribed)}

  before :each do
    login_as(subscribed_user, scope: :user)
    devise_page.visit_edit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_page_load
  end

  feature 'braintree' do

    scenario 'should not update customer detail in braintree until confirmation' do
      original_braintree = subscribed_user.braintree
      expect(UpdateBrainTreeCustomerEmailWorker.jobs.size).to eq 0
      fill_in 'user_first_name', with: 'monkey'
      fill_in 'user_last_name', with: 'luffy'
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load
      
      new_braintree = subscribed_user.reload.braintree
      expect(new_braintree.email).not_to eq original_braintree
      expect(new_braintree.first_name).not_to eq original_braintree
      expect(new_braintree.last_name).not_to eq original_braintree
    end

    scenario 'should update customer detail in braintree' do
      original_braintree = subscribed_user.braintree
      expect(UpdateBrainTreeCustomerEmailWorker.jobs.size).to eq 0
      fill_in 'user_first_name', with: 'monkey'
      fill_in 'user_last_name', with: 'luffy'
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load

      last_email = ActionMailer::Base.deliveries.last
      ctoken = last_email.body.match(/confirmation_token=[^"]+/)
      visit "/users/confirmation?#{ctoken}"
      wait_for_page_load
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      expect(UpdateBrainTreeCustomerEmailWorker.jobs.size).to eq 1
      UpdateBrainTreeCustomerEmailWorker.drain
      sleep 2
      new_braintree = subscribed_user.reload.braintree
      expect(new_braintree.email).not_to eq original_braintree
      expect(new_braintree.first_name).not_to eq original_braintree
      expect(new_braintree.last_name).not_to eq original_braintree
    end

  end

end