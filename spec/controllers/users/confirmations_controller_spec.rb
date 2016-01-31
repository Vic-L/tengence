require 'spec_helper'

feature Users::ConfirmationsController, type: :controller do
  let!(:read_only_user) {create(:user, :read_only)}
  let!(:write_only_user) {create(:user, :write_only)}
  let!(:unconfirmed_read_only_user) {create(:user, :read_only, :unconfirmed)}
  let!(:unconfirmed_write_only_user) {create(:user, :write_only, :unconfirmed)}
  let!(:pending_reconfirmation_read_only_user) {create(:user, :read_only, :pending_reconfirmation)}
  let!(:pending_reconfirmation_write_only_user) {create(:user, :write_only, :pending_reconfirmation)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    ActionMailer::Base.deliveries.clear # remove emails sent when users are created; ytf needed?
  end

  feature 'GET new' do

    feature 'non_logged_in users' do
        
      scenario 'should not be denied access' do
        get :new
        expect(response.status).to eq 200
        expect(response).to render_template 'users/confirmations/new'
      end

    end
    
    feature 'unconfirmed users' do

      feature 'read_only users' do

        scenario 'should not be denied access' do
          sign_in unconfirmed_read_only_user
          get :new
          expect(response.status).to eq 200
          expect(response).to render_template 'users/confirmations/new'
        end

      end

      feature 'write_only users' do

        scenario 'should not be denied access' do
          sign_in unconfirmed_write_only_user
          get :new
          expect(response.status).to eq 200
          expect(response).to render_template 'users/confirmations/new'
        end

      end

    end

    feature 'pending_reconfirmation users' do

      feature 'read_only users' do

        scenario 'should not be denied access' do
          sign_in pending_reconfirmation_read_only_user
          get :new
          expect(response.status).to eq 200
          expect(response).to render_template 'users/confirmations/new'
        end

      end

      feature 'write_only users' do

        scenario 'should not be denied access' do
          sign_in pending_reconfirmation_write_only_user
          get :new
          expect(response.status).to eq 200
          expect(response).to render_template 'users/confirmations/new'
        end

      end

    end

    feature 'confirmed user' do

      feature 'read_only users' do

        scenario 'should be denied access' do
          sign_in read_only_user
          get :new
          expect(response.status).to eq 302
          expect(response).to redirect_to current_tenders_path
        end

      end

      feature 'write_only users' do

        scenario 'should be denied access' do
          sign_in write_only_user
          get :new
          expect(response.status).to eq 302
          expect(response).to redirect_to current_posted_tenders_path
        end

      end

    end

  end

  feature 'POST create' do

    feature 'unconfirmed users' do

      scenario 'should send out correct email' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        post :create, user: {email: unconfirmed_read_only_user.email}
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries.last.body.match(/\/users\/confirmation\?confirmation_token=[^"]+/).nil?).to eq false
      end

      scenario 'should redirect to user sign in page' do
        post :create, user: {email: unconfirmed_read_only_user.email}
        expect(response).to redirect_to new_user_session_path
      end

    end

    feature 'pending_reconfirmation users' do

      scenario 'should send out correct email' do
        post :create, user: {email: pending_reconfirmation_write_only_user.email}
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries.last.body.match(/\/users\/confirmation\?confirmation_token=[^"]+/).nil?).to eq false
      end

      scenario 'should redirect to user sign in page' do
        post :create, user: {email: pending_reconfirmation_write_only_user.email}
        expect(response).to redirect_to new_user_session_path
      end
      
    end

    feature 'confirmed user' do

      scenario 'should not send out email' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        post :create, user: {email: read_only_user.email}
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end

      scenario 'should redirect to user sign in page' do
        post :create, user: {email: read_only_user.email}
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  feature 'GET show' do

    scenario 'with no confirmation_token' do
      get :show
      expect(response.status).to eq 422
      expect(response).to render_template :new
    end

    scenario 'with invalid confirmation_token' do
      get :show, confirmation_token: 'luffy wont become pirate king if this token is valid'
      expect(response.status).to eq 422
      expect(response).to render_template :new
    end


    feature 'with correct token' do

      feature 'non_logged_in user' do

        scenario 'unconfirmed users' do
          unconfirmed_read_only_user.send_confirmation_instructions
          get :show, confirmation_token: unconfirmed_read_only_user.confirmation_token
          expect(response).to redirect_to root_path
        end

        scenario 'pending_reconfirmation users' do
          pending_reconfirmation_write_only_user.send_confirmation_instructions
          get :show, confirmation_token: pending_reconfirmation_write_only_user.confirmation_token
          expect(response).to redirect_to root_path
        end

        feature 'confirmed user' do

          scenario 'user should not have confirmation token' do
            expect(write_only_user.confirmation_token).to eq nil
          end

        end

      end

      feature 'write_only user' do
        
        before :each do
          sign_in unconfirmed_write_only_user
        end

        scenario 'should redirect_to current_posted_tenders ' do
          unconfirmed_write_only_user.send_confirmation_instructions
          get :show, confirmation_token: unconfirmed_write_only_user.confirmation_token
          expect(response).to redirect_to current_posted_tenders_path
        end

      end

      feature 'read_only user' do
        
        before :each do
          sign_in unconfirmed_read_only_user
        end

        scenario 'should redirect_to current_posted_tenders ' do
          unconfirmed_read_only_user.send_confirmation_instructions
          get :show, confirmation_token: unconfirmed_read_only_user.confirmation_token
          expect(response).to redirect_to current_tenders_path
        end

      end

    end

  end

end