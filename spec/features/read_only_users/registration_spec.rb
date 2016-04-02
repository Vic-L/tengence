require 'spec_helper'

feature "registration as read_only users", js: true, type: :feature do
  let(:registration_page) { RegistrationPage.new }

  before :each do
    registration_page.visit_read_only_users_registration_page
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
      wait_for_ajax
      registration_page.click_unique '#submit'
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

    scenario 'with commain email domain' do
      fill_in 'user_email', with: "onepiece@gmail.com"
      registration_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@yahoo.co.uk"
      registration_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@live.com.sg"
      registration_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@hotmail.com"
      registration_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."
    end

  end

  scenario 'access_level' do
    registration_page.fill_up_form
    wait_for_ajax
    registration_page.click_unique '#submit'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(User.count).to eq 1
    expect(User.first.access_level).to eq 'read_only'
  end

  feature 'confirmation emails' do
    scenario 'should have survey' do
      registration_page.fill_up_form
      wait_for_ajax
      registration_page.click_unique '#submit'
      expect(page).to have_content "Resend confirmation instructions"

      expect(CustomDeviseMailer.deliveries.count).to eq 1
      expect(CustomDeviseMailer.deliveries.last.body.include?("Let us know where you heard of Tengence as you confirm your account by clicking on one of the options below.")).to eq true
    end

    scenario 'should be able to successfully confirm' do
      registration_page.fill_up_form
      wait_for_ajax
      registration_page.click_unique '#submit'
      expect(page).to have_content "Resend confirmation instructions"

      # last option
      visit ActionMailer::Base.deliveries.last.body.match(/\/users\/confirmation\?confirmation_token=[^"]+/).to_s
      expect(page.current_path).to eq keywords_tenders_path
    end
  end
end