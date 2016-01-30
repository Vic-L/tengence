require 'spec_helper'

feature 'password', js: true, type: :feature do
  let(:devise_page) { DevisePage.new }
  let!(:user) { create(:user, :read_only) }

  feature 'new' do

    before :each do
      devise_page.visit_new_password_page
      wait_for_page_load
    end

    feature 'validations' do

      scenario 'with nothing filled in' do
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        expect(page).to have_content 'Please enter your email.'
      end

      scenario 'with invalid email filled in' do
        fill_in 'user_email', with: Faker::Lorem.word
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        expect(page).to have_content 'Please enter a valid email.'
      end

      scenario 'with wrong email filled in' do
        fill_in 'user_email', with: Faker::Internet.email
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'     
        expect(page).to have_content 'This email is not in our database.'
      end

    end

    feature 'on successful submit' do

      scenario 'should send email with reset password token' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        fill_in 'user_email', with: user.email
        wait_for_ajax
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        wait_for_page_load

        expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries.last.body.match(/\/users\/password\/edit\?reset_password_token=[^"]+/).nil?).to eq false
      end

    end

  end

  feature 'update' do

    feature 'validations' do

      before :each do
        devise_page.visit_new_password_page
        wait_for_page_load
        fill_in 'user_email', with: user.email
        wait_for_ajax
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        wait_for_page_load
        expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'

        visit ActionMailer::Base.deliveries.last.body.match(/\/users\/password\/edit\?reset_password_token=[^"]+/).to_s
        wait_for_page_load
      end

      scenario 'with nothing filled in' do
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        expect(page).to have_content "A password is required."
        expect(page).to have_content "A password confirmation is required."
      end

      scenario 'with only password filled' do
        fill_in 'user_password', with: 'monkeyluffy'
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        expect(page).to have_content "A password confirmation is required."
      end

      scenario 'with only password confirmation filled' do
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: 'monkeyluffy'
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        expect(page).to have_content "A password is required."
      end

    end

    feature 'on successful submit' do

      before :each do
        devise_page.visit_new_password_page
        wait_for_page_load
      end

      scenario 'should succesfully update password' do
        initial_password = user.encrypted_password
        fill_in 'user_email', with: user.email
        wait_for_ajax
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        wait_for_page_load
        expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'

        visit ActionMailer::Base.deliveries.last.body.match(/\/users\/password\/edit\?reset_password_token=[^"]+/).to_s
        wait_for_page_load
        fill_in 'user_password', with: 'monkeyluffy'
        fill_in 'user_password_confirmation', with: 'monkeyluffy'
        devise_page.scroll_into_view '#submit'
        sleep 1
        devise_page.click_unique '#submit'
        
        expect(page).to have_content 'Your password has been changed successfully. You are now signed in.'
        expect(user.reload.encrypted_password).not_to eq initial_password
      end

    end

    feature 'on submit of invalid token' do
      
      scenario 'should redirect to new password path' do
        devise_page.visit_edit_password_page 'invalid_token'
        wait_for_page_load
        fill_in 'user_password', with: 'monkeyluffy'
        fill_in 'user_password_confirmation', with: 'monkeyluffy'
        devise_page.click_unique '#submit'
        expect(page.current_path).to eq new_user_password_path
      end

    end
  
  end

end