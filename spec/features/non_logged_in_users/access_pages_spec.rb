require 'spec_helper'

feature "access pages by non_logged_in users" do
  let(:tenders_page) { TendersPage.new }
  let(:pages_page) { PagesPage.new }
  let(:devise_page) { DevisePage.new }
  let(:brain_tree_page) { BrainTreePage.new }
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}

  feature 'pages_controller' do

    scenario 'home_page' do
      pages_page.visit_home_page
      expect(pages_page.current_path).to eq root_path
    end

    scenario 'terms-of-service' do
      pages_page.visit_terms_of_service_page
      expect(pages_page.current_path).to eq terms_of_service_path
    end

    scenario 'faq' do
      pages_page.visit_faq_page
      expect(pages_page.current_path).to eq faq_path
    end

  end

  feature 'passwords_controller' do

    scenario 'new_password' do
      devise_page.visit_new_password_page
      expect(tenders_page.current_path).to eq new_user_password_path
    end

    feature 'edit_password' do

      scenario 'no reset token' do
        devise_page.visit_edit_password_page
        expect(tenders_page.current_path).to eq new_user_session_path
        expect(page).to have_content "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided."
      end

      scenario 'any reset token, regardless correct or wrong' do
        devise_page.visit_edit_password_page 'some token'
        expect(tenders_page.current_path).to eq edit_user_password_path
      end

    end

  end

  feature 'confirmations_controller' do

    scenario 'resend_confirmation_page' do
      devise_page.visit_user_confirmation_page
      expect(tenders_page.current_path).to eq new_user_confirmation_path
    end

    feature 'show confirmation page' do

      scenario 'without confirmation_token' do
        devise_page.visit_user_show_confirmation_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(page).to have_content "Confirmation token can't be blank"
      end

      scenario 'with any confirmation_token token, regardless correct or wrong' do
        devise_page.visit_user_show_confirmation_page 'some token'
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(page).to have_content "Confirmation token is invalid"
      end

    end

  end

  feature 'registrations_controller' do

    scenario 'edit' do
      devise_page.visit_edit_page
      expect(devise_page.current_path).to eq new_user_session_path
      expect(devise_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'user sign_up/register page' do
      devise_page.visit_user_sign_up_page
      expect(devise_page.current_path).to eq new_user_registration_path
      devise_page.visit_register_page
      expect(devise_page.current_path).to eq register_path
    end

    scenario 'vendor register page' do
      devise_page.visit_vendor_registration_page
      expect(devise_page.current_path).to eq new_vendor_registration_path
    end

  end

  feature 'sessions_controller' do
    
    scenario 'login' do
      devise_page.visit_login_page
      expect(devise_page.current_path).to eq new_user_session_path
    end

    scenario 'logout' do
      pending 'to be cont'
      fail
    end

  end

  feature 'tenders_contollers' do

    scenario 'current_tenders' do
      tenders_page.visit_current_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'past_tenders' do
      tenders_page.visit_past_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'keywords_tenders' do
      tenders_page.visit_keywords_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'watched_tenders' do
      tenders_page.visit_watched_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'new_tender' do
      tenders_page.visit_new_tender_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'show_tender' do
      tenders_page.visit_show_tender_page tender.ref_no
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    feature 'edit_tender' do
      scenario 'edit current tender' do
        tenders_page.visit_edit_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq new_user_session_path
        expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
      end

      scenario 'edit past tender' do
        tenders_page.visit_edit_tender_page past_tender.ref_no
        expect(tenders_page.current_path).to eq new_user_session_path
        expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    scenario 'current_posted_tenders' do
      tenders_page.visit_current_posted_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'past_posted_tenders' do
      tenders_page.visit_past_posted_tenders_page
      expect(tenders_page.current_path).to eq new_user_session_path
      expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end
  
end