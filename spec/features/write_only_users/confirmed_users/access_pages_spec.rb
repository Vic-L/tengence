require 'spec_helper'

feature "access pages by confirmed write_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:pages_page) { PagesPage.new }
  let(:devise_page) { DevisePage.new }
  let(:write_only_user) {create(:user, :write_only)}
  let(:write_only_user_without_keywords) {create(:user, :write_only, :without_keywords)}
  let(:tender) {create(:tender)}
  let(:past_tender) {create(:tender, :past)}

  let(:gebiz_tender) {create(:tender, :gebiz)}
  let(:past_gebiz_tender) {create(:tender, :gebiz, :past)}
  let(:non_gebiz_tender) {create(:tender, :non_gebiz)}
  let(:past_non_gebiz_tender) {create(:tender, :non_gebiz, :past)}
  let(:inhouse_tender) {create(:tender, :inhouse)}
  let(:past_inhouse_tender) {create(:tender, :inhouse, :past)}

  let(:inhouse_tender_by_write_only_user) {create(:tender, :inhouse, postee_id: write_only_user.id)}
  let(:inhouse_tender_by_write_only_user_without_keywords) {create(:tender, :inhouse, postee_id: write_only_user_without_keywords.id)}
  let(:past_inhouse_tender_by_write_only_user) {create(:tender, :inhouse, postee_id: write_only_user.id)}
  let(:past_inhouse_tender_by_write_only_user_without_keywords) {create(:tender, :inhouse, postee_id: write_only_user_without_keywords.id)}

  feature 'with keywords' do

    before :each do
      login_as(write_only_user, scope: :user)
    end

    feature 'pages_controller' do

      scenario 'home_page' do
        pages_page.visit_home_page
        expect(pages_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'terms-of-service' do
        pages_page.visit_terms_of_service_page
        expect(pages_page.current_path).to eq terms_of_service_path
      end

      scenario 'faq' do
        pages_page.visit_faq_page
        expect(pages_page.current_path).to eq current_posted_tenders_path
        expect(pages_page).to have_content 'You are not authorized to view this page.'
      end

    end

    feature 'passwords_controller' do

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(devise_page.current_path).to eq current_posted_tenders_path
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(devise_page.current_path).to eq current_posted_tenders_path
        end

      end

    end

    feature 'confirmations_controller' do

      scenario 'new' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'Your account has been confirmed.'
      end

      feature 'show' do

        scenario 'without confirmation_token' do
          devise_page.visit_user_show_confirmation_page
          expect(tenders_page.current_path).to eq current_posted_tenders_path
          expect(devise_page).to have_content 'Your account has been confirmed.'
        end

        scenario 'with any confirmation_token token, regardless correct or wrong' do
          devise_page.visit_user_show_confirmation_page 'some token'
          expect(tenders_page.current_path).to eq current_posted_tenders_path
          expect(devise_page).to have_content 'Your account has been confirmed.'
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
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'

        devise_page.visit_register_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are not authorized to view this page.'
      end

    end

    feature 'sessions_controller' do
      
      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'
      end

      scenario 'logout' do
        pending 'to be cont'
        fail
      end

    end

    feature 'tenders_contollers' do

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

        feature 'gebiz' do
        
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page past_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

        end

        feature 'non-gebiz' do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page non_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page past_non_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end
          
        end

        feature 'inhouse' do

          feature 'by ownself' do

            scenario 'edit current tender' do
              tenders_page.visit_edit_tender_page inhouse_tender_by_write_only_user.ref_no
              expect(tenders_page.current_path).to eq edit_tender_path(inhouse_tender_by_write_only_user)
            end

            scenario 'edit past tender' do
              tenders_page.visit_edit_tender_page past_inhouse_tender_by_write_only_user.ref_no
              # expect(tenders_page.current_path).to eq current_posted_tenders_path
              # expect(tenders_page).to have_content 'This tender is not editable.'
              expect(tenders_page.current_path).to eq edit_tender_path(past_inhouse_tender_by_write_only_user)
            end

          end

          feature 'by others' do

            scenario 'edit current tender' do
              tenders_page.visit_edit_tender_page inhouse_tender_by_write_only_user_without_keywords.ref_no
              expect(tenders_page.current_path).to eq current_posted_tenders_path
              expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
            end

            scenario 'edit past tender' do
              tenders_page.visit_edit_tender_page past_inhouse_tender_by_write_only_user_without_keywords.ref_no
              expect(tenders_page.current_path).to eq current_posted_tenders_path
              expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
            end

          end

        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(devise_page.current_path).to eq past_posted_tenders_path
      end

    end

  end

  feature 'without keywords' do

    before :each do
      login_as(write_only_user_without_keywords, scope: :user)
    end

    feature 'pages_controller' do

      scenario 'home_page' do
        pages_page.visit_home_page
        expect(pages_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'terms-of-service' do
        pages_page.visit_terms_of_service_page
        expect(pages_page.current_path).to eq terms_of_service_path
      end

      scenario 'faq' do
        pages_page.visit_faq_page
        expect(pages_page.current_path).to eq current_posted_tenders_path
        expect(pages_page).to have_content 'You are not authorized to view this page.'
      end

    end

    feature 'passwords_controller' do

      scenario 'new_password' do
        devise_page.visit_new_password_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
      end

      feature 'edit_password' do

        scenario 'no reset token' do
          devise_page.visit_edit_password_page
          expect(devise_page.current_path).to eq current_posted_tenders_path
        end

        scenario 'any reset token, regardless correct or wrong' do
          devise_page.visit_edit_password_page 'some token'
          expect(devise_page.current_path).to eq current_posted_tenders_path
        end

      end

    end

    feature 'confirmations_controller' do

      scenario 'new' do
        devise_page.visit_user_confirmation_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'Your account has been confirmed.'
      end

      feature 'show' do

        scenario 'without confirmation_token' do
          devise_page.visit_user_show_confirmation_page
          expect(tenders_page.current_path).to eq current_posted_tenders_path
          expect(devise_page).to have_content 'Your account has been confirmed.'
        end

        scenario 'with any confirmation_token token, regardless correct or wrong' do
          devise_page.visit_user_show_confirmation_page 'some token'
          expect(tenders_page.current_path).to eq current_posted_tenders_path
          expect(devise_page).to have_content 'Your account has been confirmed.'
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
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'

        devise_page.visit_register_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'
      end

      scenario 'vendor register page' do
        devise_page.visit_vendor_registration_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are not authorized to view this page.'
      end

    end

    feature 'sessions_controller' do
      
      scenario 'login' do
        devise_page.visit_login_page
        expect(devise_page.current_path).to eq current_posted_tenders_path
        expect(devise_page).to have_content 'You are already signed in.'
      end

      scenario 'logout' do
        pending 'to be cont'
        fail
      end

    end

    feature 'tenders_contollers' do

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

        feature 'gebiz' do
        
          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page past_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

        end

        feature 'non-gebiz' do

          scenario 'edit current tender' do
            tenders_page.visit_edit_tender_page non_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end

          scenario 'edit past tender' do
            tenders_page.visit_edit_tender_page past_non_gebiz_tender.ref_no
            expect(tenders_page.current_path).to eq current_posted_tenders_path
            expect(tenders_page).to have_content 'This tender is not editable.'
          end
          
        end

        feature 'inhouse' do
          

          feature 'by others' do

            scenario 'edit current tender' do
              tenders_page.visit_edit_tender_page inhouse_tender_by_write_only_user.ref_no
              expect(tenders_page.current_path).to eq current_posted_tenders_path
              expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
            end

            scenario 'edit past tender' do
              tenders_page.visit_edit_tender_page inhouse_tender_by_write_only_user.ref_no
              expect(tenders_page.current_path).to eq current_posted_tenders_path
              expect(tenders_page).to have_content 'This tender does not belong to you. You are not authorized to edit it.'
            end

          end

          feature 'by ownself' do

            scenario 'edit current tender' do
              tenders_page.visit_edit_tender_page inhouse_tender_by_write_only_user_without_keywords.ref_no
              expect(tenders_page.current_path).to eq edit_tender_path(inhouse_tender_by_write_only_user_without_keywords)
            end

            scenario 'edit past tender' do
              tenders_page.visit_edit_tender_page past_inhouse_tender_by_write_only_user_without_keywords.ref_no
              expect(tenders_page.current_path).to eq edit_tender_path(past_inhouse_tender_by_write_only_user_without_keywords)
            end

          end

        end

      end

      scenario 'current_posted_tenders' do
        tenders_page.visit_current_posted_tenders_page
        expect(tenders_page.current_path).to eq current_posted_tenders_path
      end

      scenario 'past_posted_tenders' do
        tenders_page.visit_past_posted_tenders_page
        expect(devise_page.current_path).to eq past_posted_tenders_path
      end

    end

  end

end