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
          id: tender.ref_no
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
          id: tender.ref_no
        }
        expect(response.body).to eq tender.ref_no.to_json
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
          id: tender.ref_no
        }
        expect(response.status).to eq 403
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end


  feature "DELETE destroy" do
    feature "non logged in user" do
      scenario 'should be denied access' do
        delete :destroy, {
          format: :json,
          id: tender.ref_no
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
        WatchedTender.create!(tender_id: tender.ref_no, user_id: read_only_user.id) and Sidekiq::Worker.clear_all
        expect(WatchedTender.count).to eq 1
        delete :destroy, {
          format: :json,
          id: tender.ref_no
        }
        expect(response.body).to eq tender.ref_no.to_json
        expect(response.status).to eq 200
        expect(DestroyWatchedTenderWorker.jobs.size).to eq 1
        expect{DestroyWatchedTenderWorker.drain}.to change{DestroyWatchedTenderWorker.jobs.size}.by(-1)
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        delete :destroy, {
          format: :json,
          id: tender.ref_no
        }
        expect(response.status).to eq 403
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end

  end

  feature "POST mass_destroy" do
    feature "non logged in user" do
      scenario 'should be denied access' do
        delete :mass_destroy, {
          format: :json,
          id: tender.ref_no
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
        tender2 = create(:tender)
        WatchedTender.create!(tender_id: tender.ref_no, user_id: read_only_user.id) and Sidekiq::Worker.clear_all
        WatchedTender.create!(tender_id: tender2.ref_no, user_id: read_only_user.id) and Sidekiq::Worker.clear_all
        expect(WatchedTender.count).to eq 2
        delete :mass_destroy, {
          format: :json,
          ids: Tender.pluck(:ref_no)
        }
        expect(response.body).to eq Tender.pluck(:ref_no).to_json
        expect(response.status).to eq 200
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should be denied access' do
        delete :mass_destroy, {
          format: :json,
          id: tender.ref_no
        }
        expect(response.status).to eq 403
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end
    end
  end
end