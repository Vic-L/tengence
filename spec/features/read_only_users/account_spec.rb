require 'spec_helper'

feature 'account', type: :feature, js: :true do
  let(:devise_page) { DevisePage.new }
  let!(:user) { create(:user, :read_only) }
  let!(:another_user) { create(:user, :read_only) }

  before :each do
    login_as(user, scope: :user)
    devise_page.visit_edit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_page_load
  end

  feature 'validations' do

    scenario 'with nothing filled in' do
      fill_in 'user_first_name', with: ''
      fill_in 'user_last_name', with: ''
      fill_in 'user_email', with: ''
      devise_page.click_unique '#submit'
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
      devise_page.click_unique '#submit'
      expect(page).to have_content 'Please enter a valid email.'
    end

    scenario 'with commain email domain' do
      fill_in 'user_email', with: "onepiece@gmail.com"
      devise_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@yahoo.co.uk"
      devise_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@live.com.sg"
      devise_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."

      fill_in 'user_email', with: "onepiece@hotmail.com"
      devise_page.click_unique '#submit'
      expect(page).to have_content "Please use your company's email."
    end

    scenario 'with short password' do
      fill_in 'user_password', with: Faker::Internet.password(4,7)
      devise_page.click_unique '#submit'
      expect(page).to have_content 'Your password should be at least 8 characters.'
    end

    scenario 'when there is password but no confirmation password' do
      fill_in 'user_password', with: Faker::Internet.password(8)
      devise_page.click_unique '#submit'
      expect(page).to have_content "A password confirmation is required. Leave 'password' field blank if you dont intend to change your password."
    end

    scenario 'when there is password confirmation but no password' do
      fill_in 'user_password_confirmation', with: Faker::Internet.password(8)
      devise_page.click_unique '#submit'
      expect(page).to have_content "A password is required. Leave 'password confirmation' field blank if you dont intend to change your password."
    end

    scenario 'with mismatch password and password confirmation' do
      fill_in 'user_password', with: Faker::Internet.password(8)
      fill_in 'user_password_confirmation', with: Faker::Internet.password(8)
      devise_page.click_unique '#submit'
      expect(page).to have_content "Your passwords don't match."
    end

    scenario 'should not allow non unique email' do
      fill_in 'user_email', with: another_user.email
      devise_page.click_unique '#submit'
      wait_for_ajax
      expect(page).to have_content 'This email is already registered with us.'
    end

  end

  feature 'on successful update' do

    scenario 'should update password' do
      fill_in 'user_password', with: 'monkeyluffy'
      fill_in 'user_password_confirmation', with: 'monkeyluffy'
      devise_page.click_unique '#submit'
      wait_for_page_load
      expect(page).to have_content 'Your account has been updated successfully.'

      logout(:user)
      devise_page.visit_login_page
      wait_for_page_load
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'monkeyluffy'
      devise_page.click_unique '#submit'
      wait_for_page_load
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'should successfully update attributes (not email or passwords)' do
      expect(user.name).not_to eq 'monkey luffy'

      fill_in 'user_first_name', with: 'monkey'
      fill_in 'user_last_name', with: 'luffy'
      devise_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'Your account has been updated successfully.'
      expect(user.reload.name).to eq 'monkey luffy'
    end

    scenario 'should not update email right away' do
      user_email = User.first.email
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      # ytf need to click twice haiz
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      expect(page).to have_content 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.'
      expect(User.first.email).to eq user_email
      expect(User.first.email).not_to eq 'one@piece.com'
      expect(page).to have_content 'Currently waiting confirmation for: one@piece.com'
    end

    scenario 'should send reconfirmation email on email update' do
      expect(ActionMailer::Base.deliveries.count).to eq 0
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      # ytf need to click twice haiz
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load
      expect(page).to have_content 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.'
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    scenario 'should change email when account is confirmed from sent email' do
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      # ytf need to click twice haiz
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load

      expect(page).to have_content 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.'
      last_email = ActionMailer::Base.deliveries.last
      ctoken = last_email.body.match(/confirmation_token=[^"]+/)
      visit "/users/confirmation?#{ctoken}"
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      devise_page.visit_edit_page
      expect(page).not_to have_content 'Currently waiting confirmation for: one@piece.com'
    end

    # TODO chaeck if its ok to check for this in feature test
    scenario 'should not change hashed_email when reconfirmed' do
      hashed_email = user.hashed_email
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      # ytf need to click twice haiz
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load
      last_email = ActionMailer::Base.deliveries.last
      ctoken = last_email.body.match(/confirmation_token=[^"]+/)
      visit "/users/confirmation?#{ctoken}"
      wait_for_page_load
      expect(user.hashed_email).to eq hashed_email
    end

    scenario 'should nullify unconfirmed_email when reconfirmed' do
      fill_in 'user_email', with: 'one@piece.com'
      wait_for_ajax
      # ytf need to click twice haiz
      devise_page.click_unique '#submit';devise_page.click_unique '#submit'
      wait_for_page_load

      last_email = ActionMailer::Base.deliveries.last
      ctoken = last_email.body.match(/confirmation_token=[^"]+/)
      expect(user.reload.unconfirmed_email.nil?).to eq false
      visit "/users/confirmation?#{ctoken}"
      wait_for_page_load
      expect(user.reload.unconfirmed_email.nil?).to eq true
    end

  end

end