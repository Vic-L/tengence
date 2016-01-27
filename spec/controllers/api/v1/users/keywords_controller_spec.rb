require 'spec_helper'

feature Api::V1::Users::KeywordsController, type: :controller do
  let(:read_only_user) {create(:user, :read_only)}
  let(:write_only_user) {create(:user, :write_only)}

  feature "PATCH update" do
    feature "non logged in user" do

      before :each do
      end

      scenario 'should be denied access' do
        patch :update, {
          format: :json,
          keywords: Faker::Lorem.words(4).join(',')
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
        patch :update, {
          format: :json,
          keywords: Faker::Lorem.words(4).join(',')
        }
        expect(response.body).to eq({success: true}.to_json)
        expect(response.status).to eq 200
      end

      scenario 'should return error if there are too many keywords' do
        patch :update, {
          format: :json,
          keywords: Faker::Lorem.words(21).join(',')
        }
        expect(response.body).to eq "Keywords can't be more than 20"
        expect(response.status).to eq 400
      end
    end

    feature "write_only user" do

      before :each do
        sign_in write_only_user
      end

      scenario 'should be denied access' do
        patch :update, {
          format: :json,
          keywords: Faker::Lorem.words(4).join(',')
        }
        expect(response.status).to eq 403
        expect(response.content_type).to eq "application/json"
        expect(response.body).to eq({error: "Access Denied"}.to_json)
      end

    end
  end
end