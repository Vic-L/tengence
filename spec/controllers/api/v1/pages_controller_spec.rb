require 'spec_helper'

feature Api::V1::PagesController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}

  feature 'GET notify_error' do

    feature "non logged in user" do
      scenario 'should not be denied access' do
        get :notify_error, {
          format: :json, 
          url: Faker::Internet.url,
          method: "stub_method",
          error: "stub_error"
        }
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({ :success => true }.to_json)
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should not be denied access' do
        get :notify_error, {
          format: :json, 
          url: Faker::Internet.url,
          method: "stub_method",
          error: "stub_error"
        }
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({ :success => true }.to_json)
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should not be denied access' do
        get :notify_error, {
          format: :json, 
          url: Faker::Internet.url,
          method: "stub_method",
          error: "stub_error"
        }
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({ :success => true }.to_json)
      end
    end

  end

  feature 'POST demo_email' do

    feature "non logged in user" do
      scenario 'should not be denied access' do
        post :demo_email, {
          format: :json,
          demo_email: Faker::Internet.email
        }
        expect(response.content_type).to eq "text/javascript"
        expect(response.body).to eq "$('#email-demo-submitted-button').slideDown();$('#demo-email-form fieldset').slideUp();"
        expect(response.status).to eq 200
      end

      scenario 'should send demo email asynchronously' do
        expect(Sidekiq::Worker.jobs.size).to eq 0
        post :demo_email, {
          format: :json,
          demo_email: Faker::Internet.email
        }
        expect(Sidekiq::Worker.jobs.size).to eq 1
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should be denied access' do
        get :demo_tenders, format: :json
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        get :demo_tenders, format: :json
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end

  feature 'GET demo_tenders' do

    feature "non logged in user" do
      scenario 'should not be denied access' do
        get :demo_tenders, format: :json
        expect(response.content_type).to eq "application/json"
        expect(response).to render_template("api/v1/tenders/index.json.jbuilder")
        expect(response.status).to eq 200
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should be denied access' do
        get :demo_tenders, format: :json
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        get :demo_tenders, format: :json
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end
end