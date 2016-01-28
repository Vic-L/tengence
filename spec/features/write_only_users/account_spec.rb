require 'spec_helper'

feature 'account', type: :feature, js: :true do
  let(:devise_page) { DevisePage.new }
  let!(:user) { create(:user, :write_only) }

  feature 'validations' do

    before :each do
      login_as(user, scope: :user)
      devise_page.visit_edit_page
      wait_for_page_load
    end

    scenario 'with nothing filled in' do
      fill_in 'user_first_name', with: ''
      fill_in 'user_last_name', with: ''
      fill_in 'user_email', with: ''
      devise_page.submit_form
      expect(page).to have_content 'Please enter your first name.'
      expect(page).to have_content 'Please enter your last name.'
      expect(page).to have_content 'Please enter your email.'
      # if there no js
      # expect(page).to have_content "Email can't be blank"
      # expect(page).to have_content "First name can't be blank."
      # expect(page).to have_content "Last name can't be blank"
    end

    scenario 'with invalid email' do
      fill_in 'user_email', with: Faker::Lorem.word
      devise_page.submit_form
      expect(page).to have_content 'Please enter a valid email.'
    end

    scenario 'with short password' do
      fill_in 'user_password', with: Faker::Internet.password(4,7)
      devise_page.submit_form
      expect(page).to have_content 'Your password should be at least 8 characters.'
    end

    scenario 'when there is password but no confirmation password' do
      fill_in 'user_password', with: Faker::Internet.password(8)
      devise_page.submit_form
      expect(page).to have_content "A password confirmation is required. Leave 'password' field blank if you dont intend to change your password."
    end

    scenario 'when there is password confirmation but no password' do
      fill_in 'user_password_confirmation', with: Faker::Internet.password(8)
      devise_page.submit_form
      expect(page).to have_content "A password is required. Leave 'password confirmation' field blank if you dont intend to change your password."
    end

    scenario 'with mismatch password and password confirmation' do
      fill_in 'user_password', with: Faker::Internet.password(8)
      fill_in 'user_password_confirmation', with: Faker::Internet.password(8)
      devise_page.submit_form
      expect(page).to have_content "Your passwords don't match."
    end

  end

end