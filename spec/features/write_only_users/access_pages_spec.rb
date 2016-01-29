require 'spec_helper'

feature "access pages by write_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:devise_page) { DevisePage.new }
  let(:write_only_user) {create(:user, :write_only)}
  let(:write_only_user_without_keywords) {create(:user, :write_only, :without_keywords)}
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}
  let(:write_only_user_current_tender) {create(:tender, :inhouse, postee_id: write_only_user.id)}
  let(:write_only_user_past_tender) {create(:tender, :inhouse, :past, postee_id: write_only_user.id)}
  let(:other_user_tender) {create(:tender, :inhouse, postee_id: create(:user, :write_only))}

  feature 'confirmed' do

    feature 'with keywords' do

      before :each do
        login_as(write_only_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are already signed in.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'Your account has been confirmed.'
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
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_tender_path
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      feature 'edit_tender' do
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'

          end

        end

        feature "own's tender" do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            expect(tenders_page.current_path).to eq edit_tender_path(id: write_only_user_current_tender.ref_no)
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'The tender you want to edit is expired and cannot be edited.'
          end

        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq past_posted_tenders_path
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(page).to have_content 'You are already signed in.'
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(page).to have_content 'You are already signed in.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'Your account has been confirmed.'
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(write_only_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).not_to have_content 'You are not authorized to view this page.'
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are already signed in.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'Your account has been confirmed.'
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
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(tenders_page.current_path).to eq new_tender_path
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'You are not authorized to view this page.'
      end

      feature 'edit_tender' do
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'

          end

        end

        feature "own's tender" do
          let(:write_only_user_without_keywords_current_tender) {create(:tender, :inhouse, postee_id: write_only_user_without_keywords.id)}
          let(:write_only_user_without_keywords_past_tender) {create(:tender, :inhouse, :past, postee_id: write_only_user_without_keywords.id)}

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_without_keywords_current_tender.ref_no
            expect(tenders_page.current_path).to eq edit_tender_path(id: write_only_user_without_keywords_current_tender.ref_no)
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_without_keywords_past_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'The tender you want to edit is expired and cannot be edited.'
          end

        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(tenders_page.current_path).to eq past_posted_tenders_path
      end

      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'user sign_up/register page' do
        devise_page.visit_user_sign_up_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
        devise_page.visit_register_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'user edit page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
      end

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(tenders_page).to have_content 'Your account has been confirmed.'
      end

    end

  end

  let(:write_only_unconfirmed_user) {create(:user, :write_only, :unconfirmed)}
  let(:write_only_unconfirmed_user_without_keywords) {create(:user, :write_only, :without_keywords, :unconfirmed)}

  feature 'unconfirmed' do

    feature 'with keywords' do

      before :each do
        login_as(write_only_unconfirmed_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
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
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'

          end

        end

        feature "own's tender" do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

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

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(write_only_unconfirmed_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
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
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'

          end

        end

        feature "own's tender" do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

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

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

    end

  end

  let(:write_only_pending_reconfirmation_user) {create(:user, :write_only, :unconfirmed)}
  let(:write_only_pending_reconfirmation_user_without_keywords) {create(:user, :write_only, :without_keywords, :pending_reconfirmation)}

  feature 'pending_reconfirmation' do

    feature 'with keywords' do

      before :each do
        login_as(write_only_pending_reconfirmation_user, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
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
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'

          end

        end

        feature "own's tender" do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

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

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

    end

    feature 'without keywords' do

      before :each do
        login_as(write_only_pending_reconfirmation_user_without_keywords, scope: :user)
      end

      scenario 'home_page' do
        tenders_page.visit_home_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'passwords' do
        devise_page.visit_new_password_page
        expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
      end

      scenario 'resend_confirmation_page' do
        tenders_page.visit_resend_confirmation_page
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
        
        feature "other people's tender" do
          
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page other_user_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'
          end

        end

        feature "non inhouse tender" do

          scenario 'edit current tender' do
            
            tenders_page.visit_edit_tender_page tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
        expect(tenders_page).to have_content 'Please confirm your account first.'

          end

        end

        feature "own's tender" do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            expect(tenders_page.current_path).to eq new_user_confirmation_path
            expect(tenders_page).to have_content 'Please confirm your account first.'
          end

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

      scenario 'user confirmation page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
      end

    end
  end
end