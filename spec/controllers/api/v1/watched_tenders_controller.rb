require 'spec_helper'

feature Api::V1::WatchedTendersController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}
  let!(:tender) {create(:tender)}

  feature "GET index" do

    feature "non logged in user" do
      scenario 'should be denied access' do
        get :index, format: :json
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should not be denied access' do
        get :index, format: :json
        expect(response).to render_template("api/v1/tenders/index.json.jbuilder")
        expect(response.status).to eq 200
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        get :index, format: :json
        expect(response.status).to eq 403
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end

  feature "POST create" do

    feature "non logged in user" do
      scenario 'should be denied access' do
        post :create, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should not be denied access' do
        expect(WatchedTender.count).to eq 0
        post :create, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response.body).to eq Tender.first.ref_no.to_json
        expect(response.status).to eq 200
        expect(WatchedTender.count).to eq 1
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        post :create, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response.status).to eq 403
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end



end