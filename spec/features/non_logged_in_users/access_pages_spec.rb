require 'spec_helper'

feature "access pages by non_logged_in users" do
  let(:tenders_page) { TendersPage.new }
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}

  scenario 'home_page' do
    tenders_page.visit_home_page
    expect(tenders_page.current_path).to eq root_path
  end

  scenario 'resend_confirmation_page' do
    tenders_page.visit_resend_confirmation_page
    expect(tenders_page.current_path).to eq new_user_confirmation_path
  end

  scenario 'terms-of-service' do
    tenders_page.visit_terms_of_service_page
    expect(tenders_page.current_path).to eq terms_of_service_path
  end

  scenario 'account_page' do
    tenders_page.visit_account_page
    expect(tenders_page.current_path).to eq new_user_session_path
    expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
  end

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

  let(:devise_page) { DevisePage.new }
  
  scenario 'login' do
    devise_page.visit_login_page
    expect(devise_page.current_path).to eq new_user_session_path
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

  scenario 'user edit page' do
    devise_page.visit_edit_page
    expect(tenders_page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'user confirmation page' do
    devise_page.visit_user_confirmation_page
    expect(devise_page.current_path).to eq new_user_confirmation_path
  end
end