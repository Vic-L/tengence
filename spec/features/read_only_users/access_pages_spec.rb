require 'spec_helper'

feature "access pages by read_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:devise_page) { DevisePage.new }
  let(:read_only_user) {create(:user, :read_only)}
  let(:read_only_user_without_keywords) {create(:user, :read_only, :without_keywords)}
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}

  feature 'confirmed' do

    feature 'with keywords' do

      before :each do
        login_as(read_only_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).not_to have_content 'You are not authorized to view this page.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are already signed in.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq current_tenders_path
          expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq current_tenders_path
          expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq current_tenders_path
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq current_tenders_path
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq past_tenders_path
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq watched_tenders_path
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq tender_path(id: tender.ref_no)
      end

      scenario 'edit current tender' do
        tenders_page.visit_edit_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'edit past tender' do
        tenders_page.visit_edit_tender_page past_tender.ref_no
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end
  
      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq current_tenders_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are already signed in.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are already signed in.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(read_only_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).not_to have_content 'You are not authorized to view this page.'
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq keywords_tenders_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq keywords_tenders_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).not_to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq tender_path(id: tender.ref_no)
      end

      feature 'edit_tender' do

        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq keywords_tenders_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end

  end

  let(:read_only_unconfirmed_user) {create(:user, :read_only, :unconfirmed)}
  let(:read_only_unconfirmed_user_without_keywords) {create(:user, :read_only, :without_keywords, :unconfirmed)}

  feature 'unconfirmed' do

    feature 'with keywords' do

      before :each do
        login_as(read_only_unconfirmed_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_tender' do

        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(read_only_unconfirmed_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_tender' do

        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end

  end

  let(:read_only_pending_reconfirmation_user) {create(:user, :read_only, :unconfirmed)}
  let(:read_only_pending_reconfirmation_user_without_keywords) {create(:user, :read_only, :without_keywords, :pending_reconfirmation)}

  feature 'pending_reconfirmation' do

    feature 'with keywords' do

      before :each do
        login_as(read_only_pending_reconfirmation_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_tender' do

        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(read_only_pending_reconfirmation_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        tenders_page.visit_terms_of_service_page
        expect(tenders_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        tenders_page.visit_account_page
        expect(tenders_page.current_path).to eq edit_user_registration_path
      end

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_tender' do

        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(tenders_page.current_path).to eq new_user_confirmation_path
          expect(tenders_page).to have_content 'Please confirm your account first.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

    end
    
  end

end