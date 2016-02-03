require 'spec_helper'

feature BrainTreeController, type: :controller do
  let!(:yet_to_subscribe_user) { create(:user, :braintree) }
  let!(:subscribed_user) { create(:user, :braintree, :subscribed) }
  let!(:unsubscribed_user) { create(:user, :braintree, :unsubscribed) }

  feature 'GET billing' do
  end

  feature 'GET subscribe' do
  end

  feature 'POST create_payment' do
    
    before :each do
      request.env["HTTP_REFERER"] = subscribe_path
      sign_in yet_to_subscribe_user
    end

    feature 'with valid nonce' do

      scenario 'should redirect_to billing_path' do
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(response).to redirect_to billing_path
      end

      scenario 'should give user braintree_subscription_id' do
        expect(yet_to_subscribe_user.braintree_subscription_id).to eq nil
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(yet_to_subscribe_user.reload.braintree_subscription_id).not_to eq nil
      end

      scenario 'should give user default_payment_method_token' do
        expect(yet_to_subscribe_user.default_payment_method_token).to eq nil
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(yet_to_subscribe_user.reload.default_payment_method_token).not_to eq nil
      end

    end

    feature 'with invalid nonce' do

      scenario 'should redirect back to subscribe_path' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(response).to redirect_to subscribe_path
      end

      scenario 'should not give user braintree_subscription_id' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(yet_to_subscribe_user.reload.braintree_subscription_id).to eq nil
      end

      scenario 'should not give user default_payment_method_token' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(yet_to_subscribe_user.reload.default_payment_method_token).to eq nil
      end

    end

  end

  feature 'POST update_payment' do

    before :each do
      sign_in yet_to_subscribe_user
      post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
      request.env["HTTP_REFERER"] = change_payment_path
      yet_to_subscribe_user.reload
    end

    feature 'with same valid payment_method' do  

      scenario 'should redirect_to billing_path' do
        post :update_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(response).to redirect_to billing_path
      end

      scenario 'should not change user braintree_subscription_id' do
        original_braintree_subscription_id = yet_to_subscribe_user.braintree_subscription_id
        post :update_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(yet_to_subscribe_user.reload.braintree_subscription_id).to eq original_braintree_subscription_id
      end

      scenario 'should not change user default_payment_method_token' do
        # NOTE test this in feature spec
        # original_default_payment_method_token = yet_to_subscribe_user.default_payment_method_token
        # post :update_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        # expect(yet_to_subscribe_user.default_payment_method_token).to eq original_default_payment_method_token
      end

    end

    feature 'with another payment_method' do

      feature 'with valid nonce' do

        scenario 'should redirect_to billing_path' do
          post :update_payment, { payment_method_nonce: 'fake-valid-visa-nonce'}
          expect(response).to redirect_to billing_path
        end

        scenario 'should not change user braintree_subscription_id' do
          original_braintree_subscription_id = yet_to_subscribe_user.braintree_subscription_id
          post :update_payment, { payment_method_nonce: 'fake-valid-visa-nonce'}
          expect(yet_to_subscribe_user.reload.braintree_subscription_id).to eq original_braintree_subscription_id
        end

        scenario 'should change user default_payment_method_token' do
          original_default_payment_method_token = yet_to_subscribe_user.default_payment_method_token
          post :update_payment, { payment_method_nonce: 'fake-valid-visa-nonce'}
          expect(yet_to_subscribe_user.reload.default_payment_method_token).not_to eq original_default_payment_method_token
        end

        scenario 'should not cause a new transaction' do
          original_transaction_count = yet_to_subscribe_user.braintree_subscription.transactions.count
          post :update_payment, { payment_method_nonce: 'fake-valid-visa-nonce'}
          expect(yet_to_subscribe_user.reload.braintree_subscription.transactions.count).to eq original_transaction_count
        end

        scenario 'should change the payment token in braintree subscription' do
          original_subscription_payment_token = yet_to_subscribe_user.braintree_subscription.payment_method_token
          post :update_payment, { payment_method_nonce: 'fake-valid-visa-nonce'}
          expect(yet_to_subscribe_user.reload.braintree_subscription.payment_method_token).not_to eq original_subscription_payment_token
        end

      end

      feature 'with invalid nonce' do

        scenario 'should redirect back to subscribe_path' do
          post :update_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
          expect(response).to redirect_to change_payment_path
        end

        scenario 'should not change user braintree_subscription_id' do
          original_braintree_subscription_id = yet_to_subscribe_user.braintree_subscription_id
          post :update_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
          expect(yet_to_subscribe_user.reload.braintree_subscription_id).to eq original_braintree_subscription_id
        end

        scenario 'should not change user default_payment_method_token' do
          original_default_payment_method_token = yet_to_subscribe_user.default_payment_method_token
          post :update_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
          expect(yet_to_subscribe_user.reload.default_payment_method_token).to eq original_default_payment_method_token
        end

        scenario 'should not change the payment token in braintree subscription' do
          original_subscription_payment_token = yet_to_subscribe_user.braintree_subscription.payment_method_token
          post :update_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
          expect(yet_to_subscribe_user.reload.braintree_subscription.payment_method_token).to eq original_subscription_payment_token
        end

      end

    end

  end

  feature 'POST unsubscribe' do

    feature 'yet_to_subscribe_user' do

      before :each do
        sign_in yet_to_subscribe_user
        request.env["HTTP_REFERER"] = edit_user_registration_path
      end

      scenario 'should redirect_to back' do
        post :unsubscribe
        expect(response).to redirect_to edit_user_registration_path
      end

    end

    feature 'subscribed_user' do

      before :each do
        sign_in subscribed_user
        request.env["HTTP_REFERER"] = change_payment_path
      end

      scenario 'should redirect_to change_payment_path' do
        post :unsubscribe
        expect(response).to redirect_to change_payment_path
      end

    end

    feature 'unsubscribed_user' do

      before :each do
        sign_in unsubscribed_user
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        request.env["HTTP_REFERER"] = edit_user_registration_path
      end

      scenario 'should redirect_to billing_path' do
        post :unsubscribe
        expect(response).to redirect_to billing_path
      end

    end    

  end

end