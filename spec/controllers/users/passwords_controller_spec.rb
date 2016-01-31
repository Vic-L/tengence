require 'spec_helper'

feature Users::PasswordsController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  feature "GET new" do
  
    feature "non logged in user" do

      scenario 'should not be denied access' do
        get :new
        expect(response).to render_template 'users/passwords/new'
        expect(response.status).to eq 200
      end

    end

    feature "read_only user" do

      before :each do
        sign_in read_only_user
      end
      
      scenario 'should be denied access' do
        get :new
        expect(response).to redirect_to root_path
        expect(response.status).to eq 302
      end

    end

    feature "write_only user" do
      
      before :each do
        sign_in write_only_user
      end
      
      scenario 'should be denied access' do
        get :new
        expect(response).to redirect_to root_path
        expect(response.status).to eq 302
      end

    end

  end

  feature "GET edit" do

    feature 'without reset_password_token' do

      feature "non logged in user" do

        scenario 'should be denied access' do
          get :edit
          expect(response).to redirect_to new_user_session_path
          expect(response.status).to eq 302
        end

      end

      feature "read_only user" do

        before :each do
          sign_in read_only_user
        end
        
        scenario 'should be denied access' do
          get :edit
          expect(response).to redirect_to root_path
          expect(response.status).to eq 302
        end

      end

      feature "write_only user" do
        
        before :each do
          sign_in write_only_user
        end
        
        scenario 'should be denied access' do
          get :edit
          expect(response).to redirect_to root_path
          expect(response.status).to eq 302
        end

      end

    end

    feature 'with reset_password_token, regardless valid or not' do

      feature "non logged in user" do

        scenario 'should not be denied access' do
          get :edit, reset_password_token: 'luffy wont become pirate king if this token is valid'
          expect(response).to render_template 'users/passwords/edit'
          expect(response.status).to eq 200
        end

      end

      feature "read_only user" do

        before :each do
          sign_in read_only_user
        end
        
        scenario 'should be denied access' do
          get :edit, reset_password_token: 'luffy wont become pirate king if this token is valid'
          expect(response).to redirect_to root_path
          expect(response.status).to eq 302
        end

      end

      feature "write_only user" do
        
        before :each do
          sign_in write_only_user
        end
        
        scenario 'should not be denied access' do
          get :edit, reset_password_token: 'luffy wont become pirate king if this token is valid'
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end

      end

    end
  end

  feature "POST create" do

    scenario 'should send out correct email' do
      expect(ActionMailer::Base.deliveries.count).to eq 0
      post :create, user: {email: read_only_user.email}
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(ActionMailer::Base.deliveries.last.body.match(/\/users\/password\/edit\?reset_password_token=[^"]+/).nil?).to eq false
    end

    scenario 'should redirect to user sign in page' do
      post :create, user: {email: read_only_user.email}
      expect(response).to redirect_to new_user_session_path
    end

  end

  feature 'POST update' do

    scenario 'should redirect to new password path if reset_password_token is invalid' do
      post :update, user: {
        reset_password_token: 'luffy wont become pirate king if this token is valid',
        password: 'monkeyluffy',
        password_confirmation: 'monkeyluffy'
      }
      expect(response.status).to eq 302
      expect(response).to redirect_to new_user_password_path
    end

    scenario 'should redirect the read_only user to current_tenders if reset_password_token is' do
      token = read_only_user.send_reset_password_instructions
      post :update, user: {
        reset_password_token: token,
        password: 'monkeyluffy',
        password_confirmation: 'monkeyluffy'
      }
      expect(response.status).to eq 302
      expect(response).to redirect_to current_tenders_path
    end

    scenario 'should redirect the user to current_posted_tenders if reset_password_token is' do
      token = write_only_user.send_reset_password_instructions
      post :update, user: {
        reset_password_token: token,
        password: 'monkeyluffy',
        password_confirmation: 'monkeyluffy'
      }
      expect(response.status).to eq 302
      expect(response).to redirect_to current_posted_tenders_path
    end

  end

end