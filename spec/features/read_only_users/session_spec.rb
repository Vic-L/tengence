require 'spec_helper'

feature 'session pages by read_only users', type: :feature, js: true do
  let(:devise_page) { DevisePage.new }
  let!(:user) { create(:user, :read_only) }
  let!(:user_without_keywords) { create(:user, :read_only, :without_keywords) }
    
  feature 'login' do

    before :each do
      devise_page.visit_login_page
      wait_for_page_load
    end
  
    feature 'validations' do

      scenario 'with nothing filled in' do
        devise_page.click_unique '#submit'
        expect(page).to have_content 'An email is required.'
        expect(page).to have_content 'A password is required.'
      end

      scenario 'with invalid email and short password' do
        devise_page.fill_up_login_form Faker::Lorem.word, Faker::Internet.password(4,7)
        devise_page.click_unique '#submit'
        expect(page).to have_content 'Your email is in an invalid format.'
        expect(page).to have_content 'Your password should be at least 8 characters.'
      end

      scenario 'wrong password' do
        devise_page.fill_up_login_form user.email, Faker::Internet.password(8)
        devise_page.click_unique '#submit'
        expect(page).to have_content 'Invalid email or password.'
      end

      scenario 'wrong email' do
        devise_page.fill_up_login_form Faker::Internet.email, 'password'
        devise_page.click_unique '#submit'
        expect(page).to have_content 'Invalid email or password.'
      end

    end

    scenario 'successful login' do
      devise_page.fill_up_login_form user.email, 'password'
      wait_for_ajax
      devise_page.click_unique '#submit'
      expect(page).to have_content 'Signed in successfully.'
    end

      
    scenario 'should redirect to current_tenders for users with keywords' do
      wait_for_page_load
      devise_page.fill_up_login_form user.email, 'password'
      devise_page.click_unique '#submit'
      expect(page.current_path).to eq current_tenders_path
    end

    scenario 'should redirect to keywords_tenders for users with keywords' do
      wait_for_page_load
      devise_page.fill_up_login_form user_without_keywords.email, 'password'
      devise_page.click_unique '#submit'
      expect(page.current_path).to eq keywords_tenders_path
      expect(page).to have_content "Get started with Tengence by filling in keywords related to your business."
    end

  end

  feature 'logout' do
    
    scenario 'should logout successfully' do
      login_as(user, scope: :user)
      devise_page.visit_edit_page
      wait_for_page_load
      devise_page.click_logout
      expect(page.current_path).to eq root_path
      expect(page).to have_content 'Signed out successfully.'
    end

  end

end