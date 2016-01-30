require 'spec_helper'

feature PagesController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}

  feature 'GET home' do
    
    feature 'non_logged_in user' do

      scenario 'should not be denied access' do
        get :home
        expect(response.status).to eq 200
        expect(response).to render_template 'pages/home'
      end

    end

    feature 'read_only user' do

      # error y not 302
      scenario 'should be redirected to current_tenders page' do
        sign_in read_only_user
        get :home
        expect(response.status).to eq 302
        expect(response).to redirect_to current_tenders_path
      end

    end

    feature 'write_only user' do

      scenario 'should be redirected to current_tenders page' do
        sign_in write_only_user
        get :home
        expect(response.status).to eq 302
        expect(response).to redirect_to current_posted_tenders_path
      end

    end

  end

  feature 'GET terms_of_service' do

    feature 'non_logged_in user' do

      scenario 'should not be denied access' do
        get :terms_of_service
        expect(response.status).to eq 200
        expect(response).to render_template 'pages/terms_of_service'
      end

    end

    feature 'read_only user' do

      scenario 'should be redirected to current_tenders page' do
        sign_in read_only_user
        get :terms_of_service
        expect(response.status).to eq 200
        expect(response).to render_template 'pages/terms_of_service'
      end

    end

    feature 'write_only user' do

      scenario 'should be redirected to current_tenders page' do
        sign_in write_only_user
        get :terms_of_service
        expect(response.status).to eq 200
        expect(response).to render_template 'pages/terms_of_service'
      end

    end

  end

  feature 'GET refresh_cloudsearch' do
    scenario 'should not be denied access by anyone' do
      get :refresh_cloudsearch
      expect(response.content_type).to eq "application/json"
      expect(response.body).to eq("success".to_json)
    end
  end

  feature 'GET contact_us_email' do

    scenario 'give error message if invalid params are supplied' do
      post :contact_us_email, {
        name: '',
        email: nil,
        # comments: "I'm gonna become the king of pirates!"
      }
      expect(response.content_type).to eq "application/json"
      expect(response.body).to eq("Please fill up all fields.".to_json)
    end

    scenario 'give error message if invalid params are supplied' do
      post :contact_us_email, {
        name: "luffy",
        email: "one@piece.com",
        comments: "I'm gonna become the king of pirates!"
      }
      expect(response.content_type).to eq "application/json"
      message = "We have received your email. The Tengence team will contact you shortly."
      message = "<div id='success_page'>"
      message += "<h1 class='success-message'>Email Sent Successfully.</h1>"
      message += "<p>Thank you <strong>luffy</strong>, your message has been submitted to us.</p>"
      message += "<p>The Tengence team will contact you shortly.</p>"
      message += "</div>"
      expect(response.body).to eq(message.to_json)
    end

  end

end