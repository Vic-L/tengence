require 'spec_helper'

feature 'session pages by read_only users', type: :feature, js: true do
  let(:devise_page) { DevisePage.new }
  let!(:user) { create(:user, :write_only) }
    
  feature 'login' do

    before :each do
      devise_page.visit_login_page
      wait_for_page_load
    end
  
    feature 'validations' do

      scenario 'with nothing filled in' do
        devise_page.submit_form
        expect(page).to have_content 'An email is required.'
        expect(page).to have_content 'A password is required.'
      end

      scenario 'with invalid email and short password' do
        devise_page.fill_up_login_form Faker::Lorem.word, Faker::Internet.password(4,7)
        devise_page.submit_form
        expect(page).to have_content 'Your email is in an invalid format.'
        expect(page).to have_content 'Your password should be at least 8 characters.'
      end

      scenario 'wrong password' do
        devise_page.fill_up_login_form user.email, Faker::Internet.password(8)
        devise_page.submit_form
        expect(page).to have_content 'Invalid email or password.'
      end

      scenario 'wrong email' do
        devise_page.fill_up_login_form Faker::Internet.email, 'password'
        devise_page.submit_form
        expect(page).to have_content 'Invalid email or password.'
      end

    end

    scenario 'successful login' do
      devise_page.visit_login_page
      devise_page.fill_up_login_form user.email, 'password'
      devise_page.submit_form
      expect(page).to have_content 'Signed in successfully.'
    end

      
    scenario 'should redirect to current_posted_tenders for users' do
      devise_page.visit_login_page
      wait_for_page_load
      devise_page.fill_up_login_form user.email, 'password'
      devise_page.submit_form
      expect(page.current_path).to eq current_posted_tenders_path
    end

  end

  feature 'logout' do
    
    scenario 'should logout successfully' do
      login_as(user, scope: :user)
      devise_page.visit_edit_page
      wait_for_page_load
      devise_page.click_logout
    end

  end

end