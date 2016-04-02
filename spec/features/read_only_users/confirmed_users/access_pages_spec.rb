require 'spec_helper'

feature "access pages by confirmed read_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:pages_page) { PagesPage.new }
  let(:devise_page) { DevisePage.new }
  let(:read_only_user) {create(:user)}
  let(:read_only_user_without_keywords) {create(:user, :without_keywords)}
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}

  feature 'with keywords' do

    before :each do
      login_as(read_only_user, scope: :user)
    end

    feature 'pages_controller' do

      scenario 'home_page' do
        pages_page.visit_home_page
        expect(tenders_page.current_path).to eq current_tenders_path
      end

      scenario 'terms-of-service' do
        pages_page.visit_terms_of_service_page
        expect(pages_page.current_path).to eq terms_of_service_path
      end

      scenario 'faq' do
        pages_page.visit_faq_page
        expect(pages_page.current_path).to eq faq_path
      end

      scenario 'welcome' do
        pages_page.visit_welcome_page
        expect(tenders_page.current_path).not_to eq welcome_path
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content "Your account has been confirmed."
      end

    end

    feature 'passwords_controller' do

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

    end

    feature 'confirmations_controller' do

      scenario 'new' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content "Your account has been confirmed."
      end

      feature 'show' do

        scenario 'without confirmation_token' do
          devise_page.visit_user_show_confirmation_page
          expect(tenders_page.current_path).to eq current_tenders_path
          expect(page).to have_content "Your account has been confirmed."
        end

        scenario 'with any confirmation_token token, regardless correct or wrong' do
          devise_page.visit_user_show_confirmation_page 'some token'
          expect(tenders_page.current_path).to eq current_tenders_path
          expect(page).to have_content "Your account has been confirmed."
        end

      end

    end

    feature 'registrations_controller' do

      scenario 'edit' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
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
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

    end

    feature 'sessions_controller' do
      
      scenario 'login' do
        devise_page.visit_login_page
        expect(tenders_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are already signed in.'
      end

      scenario 'logout' do
        pending 'to be cont'
        fail
      end

    end

    feature 'tenders_contollers' do

      scenario 'current_tenders' do
        tenders_page.visit_current_tenders_page
        expect(devise_page.current_path).to eq current_tenders_path
      end

      scenario 'past_tenders' do
        tenders_page.visit_past_tenders_page
        expect(devise_page.current_path).to eq past_tenders_path
      end

      scenario 'keywords_tenders' do
        tenders_page.visit_keywords_tenders_page
        expect(devise_page.current_path).to eq keywords_tenders_path
      end

      scenario 'watched_tenders' do
        tenders_page.visit_watched_tenders_page
        expect(devise_page.current_path).to eq watched_tenders_path
      end

      scenario 'new_tender' do
        tenders_page.visit_new_tender_page
        expect(devise_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'show_tender' do
        tenders_page.visit_show_tender_page tender.ref_no
        expect(devise_page.current_path).to eq tender_path(tender)
      end

      feature 'edit_tender' do
        
        scenario 'edit current tender' do
          tenders_page.visit_edit_tender_page tender.ref_no
          expect(devise_page.current_path).to eq current_tenders_path
          expect(page).to have_content 'You are not authorized to view this page.'
        end

        scenario 'edit past tender' do
          tenders_page.visit_edit_tender_page past_tender.ref_no
          expect(devise_page.current_path).to eq current_tenders_path
          expect(page).to have_content 'You are not authorized to view this page.'
        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(devise_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(devise_page.current_path).to eq current_tenders_path
        expect(page).to have_content 'You are not authorized to view this page.'
      end

    end

  end

  feature 'without keywords' do

    before :each do
      login_as(read_only_user_without_keywords, scope: :user)
    end

    feature 'pages_controller' do

      scenario 'home_page' do
        pages_page.visit_home_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
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
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

      end

    end

    feature 'confirmations_controller' do

      scenario 'new' do
        devise_page.visit_user_confirmation_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      feature 'show' do

        scenario 'without confirmation_token' do
          devise_page.visit_user_show_confirmation_page
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

        scenario 'with any confirmation_token token, regardless correct or wrong' do
          devise_page.visit_user_show_confirmation_page 'some token'
          expect(tenders_page.current_path).to eq keywords_tenders_path
          expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
        end

      end

    end

    feature 'registrations_controller' do

      scenario 'edit' do
        devise_page.visit_edit_page
        expect(devise_page.current_path).to eq edit_user_registration_path
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
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

    end

    feature 'sessions_controller' do
      
      scenario 'login' do
        devise_page.visit_login_page
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'logout' do
        pending 'to be cont'
        fail
      end

    end

    feature 'tenders_contollers' do

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
        expect(tenders_page.current_path).to eq keywords_tenders_path
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
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
        expect(devise_page.current_path).to eq keywords_tenders_path
        # expect(page).to have_content 'You are not authorized to view this page.'
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(devise_page.current_path).to eq keywords_tenders_path
        # expect(page).to have_content 'You are not authorized to view this page.'
        expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
      end

    end

  end

end
