require 'spec_helper'

feature Api::V1::TendersController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}
  let!(:tender) {create(:tender)}

  feature "GET show" do
    feature 'non_logged_in_user' do
      scenario 'should not be denied access' do
        get :show, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response).to render_template("api/v1/tenders/show")
        expect(response.status).to eq 200
      end
    end

    feature "write_only user" do
      before :each do
        sign_in write_only_user
      end
      scenario 'should not be denied access' do
        get :show, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response).to render_template("api/v1/tenders/show")
        expect(response.status).to eq 200
      end
    end

    feature "read_only user" do
      before :each do
        sign_in read_only_user
      end
      scenario 'should not be denied access' do
        get :show, {
          format: :json,
          id: Tender.first.ref_no
        }
        expect(response).to render_template("api/v1/tenders/show")
        expect(response.status).to eq 200
      end
    end
  end
end