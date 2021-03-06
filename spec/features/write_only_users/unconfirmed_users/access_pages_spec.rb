require 'spec_helper'

feature "access pages by write_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:devise_page) { DevisePage.new }
  let(:pages_page) { PagesPage.new }
  let(:write_only_unconfirmed_user) {create(:user, :write_only, :unconfirmed)}
  let(:write_only_unconfirmed_user_without_keywords) {create(:user, :write_only, :without_keywords, :unconfirmed)}

  let(:other_user) {create(:user, :write_only)}
  let(:other_user_tender) { create(:tender, postee_id: other_user) }
  let(:tender) { create(:tender) }

  feature 'unconfirmed' do

    feature 'with keywords' do

      before :each do
        login_as(write_only_unconfirmed_user, scope: :user)
      end

      scenario 'home_page' do
        pages_page.visit_home_page
        expect(pages_page.current_path).to eq new_user_confirmation_path
        expect(pages_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(devise_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(devise_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        pages_page.visit_terms_of_service_page
        expect(pages_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
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
            # tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            # expect(tenders_page.current_path).to eq new_user_confirmation_path
            # expect(tenders_page).to have_content 'Please confirm your account first.'
            pending 'should not happen'
            fail
          end

          scenario 'edit past tender' do
            # tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            # expect(tenders_page.current_path).to eq new_user_confirmation_path
            # expect(tenders_page).to have_content 'Please confirm your account first.'
            pending 'should not happen'
            fail
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
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).to have_content 'Please confirm your account first.'
        devise_page.visit_register_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).to have_content 'Please confirm your account first.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).to have_content 'Please confirm your account first.'
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
        pages_page.visit_home_page
        expect(pages_page.current_path).to eq new_user_confirmation_path
        expect(pages_page).to have_content 'Please confirm your account first.'
      end

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).to have_content 'Please confirm your account first.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(devise_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(devise_page.current_path).to eq new_user_confirmation_path
          # expect(page).to have_content "You are already signed in."
        end

      end

      scenario 'resend_confirmation_page' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq new_user_confirmation_path
        expect(devise_page).not_to have_content 'Please confirm your account first.'
      end

      scenario 'terms-of-service' do
        pages_page.visit_terms_of_service_page
        expect(pages_page.current_path).to eq terms_of_service_path
      end

      scenario 'account_page' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
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
            # tenders_page.visit_edit_tender_page write_only_user_current_tender.ref_no
            # expect(tenders_page.current_path).to eq new_user_confirmation_path
            # expect(tenders_page).to have_content 'Please confirm your account first.'
            pending 'should not happen'
            fail
          end

          scenario 'edit past tender' do
            # tenders_page.visit_edit_tender_page write_only_user_past_tender.ref_no
            # expect(tenders_page.current_path).to eq new_user_confirmation_path
            # expect(tenders_page).to have_content 'Please confirm your account first.'
            pending 'should not happen'
            fail
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