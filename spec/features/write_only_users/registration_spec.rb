require 'spec_helper'

feature "registration as write_only users", js: true, type: :feature do
  let(:registration_page) { RegistrationPage.new }

  before :each do
    registration_page.visit_write_only_users_registration_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_page_load
  end

  feature 'validations' do

    scenario 'with nothing filled in' do
      registration_page.click_unique '#submit'
      expect(page).to have_content 'Your first name is required.'
      expect(page).to have_content 'Your last name is required.'
      expect(page).to have_content 'Your company name is required.'
      expect(page).to have_content 'An email is required.'
      expect(page).to have_content 'A password is required.'
      expect(page).to have_content 'Please check this.'
    end

    scenario 'with everything filled up' do
      registration_page.fill_up_form
      registration_page.click_unique '#submit';
      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page.current_path.include? new_user_confirmation_path).to eq false
      expect(page.current_path).to eq welcome_path
    end

    scenario 'with short password' do
      registration_page.fill_up_form
      fill_in 'user_password', with: Faker::Internet.password(4,7)
      registration_page.click_unique '#submit'
      expect(page).to have_content 'Your password should be at least 8 characters.'
    end

    scenario 'with invalid email' do
      registration_page.fill_up_form
      fill_in 'user_email', with: Faker::Lorem.word
      registration_page.click_unique '#submit'
      expect(page).to have_content 'Your email is in an invalid format.'
    end
  end

  scenario 'access_level' do
    registration_page.fill_up_form
    registration_page.click_unique '#submit';registration_page.click_unique '#submit'
    expect(User.count).to eq 1
    expect(User.first.access_level).to eq 'write_only'
  end
end