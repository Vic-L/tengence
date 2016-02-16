require 'spec_helper'

feature BrainTreeController, type: :controller do
  let!(:yet_to_subscribe_user) { create(:user, :braintree) }
  let!(:subscribed_user) { create(:user, :braintree, :subscribed_one_month) }
  let!(:unsubscribed_user) { create(:user, :braintree, :unsubscribed_one_month) }
  let!(:unconfirmed_user) { create(:user, :braintree, :unconfirmed) }
  let!(:pending_reconfirmation_user) { create(:user, :braintree, :pending_reconfirmation) }

  feature 'GET billing' do

    scenario 'should be ok for all confirmed users' do
      sign_in yet_to_subscribe_user
      get :billing
      expect(response.status).to eq 200
      expect(response).to render_template 'brain_tree/billing'

      sign_in subscribed_user
      get :billing
      expect(response.status).to eq 200
      expect(response).to render_template 'brain_tree/billing'

      sign_in unsubscribed_user
      get :billing
      expect(response.status).to eq 200
      expect(response).to render_template 'brain_tree/billing'
    end

    scenario 'should be denied access for all unconfirmed/pending_reconfirmation users' do
      sign_in unconfirmed_user
      get :billing
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path

      sign_in pending_reconfirmation_user
      get :billing
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path
    end

  end

  feature 'GET subscribe' do

    scenario 'should be ok yet_to_subscribe_user' do
      sign_in yet_to_subscribe_user
      request.env["HTTP_REFERER"] = edit_user_registration_path
      get :subscribe
      expect(response).to render_template 'brain_tree/subscribe'
    end

    scenario 'should be redirected for subscribed_user' do
      sign_in subscribed_user
      get :subscribe
      expect(response).to redirect_to billing_path
    end

    scenario 'should be redirected for unsubscribed_user' do
      sign_in unsubscribed_user
      get :subscribe
      expect(response).to redirect_to billing_path
    end

    scenario 'should be ok for unsubscribed_user after last billing date' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        sign_in unsubscribed_user
        request.env["HTTP_REFERER"] = edit_user_registration_path
        get :subscribe
        expect(response).to render_template 'brain_tree/subscribe'
        sign_out unsubscribed_user
      end
    end

    scenario 'should be denied access for all confirmed users' do
      sign_in unconfirmed_user
      get :subscribe
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path

      sign_in pending_reconfirmation_user
      get :subscribe
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path
    end

  end

  feature 'GET change_payment' do

    scenario 'should be redirected yet_to_subscribe_user' do
      sign_in yet_to_subscribe_user
      request.env["HTTP_REFERER"] = edit_user_registration_path
      get :change_payment
      expect(response).to redirect_to billing_path
    end

    scenario 'should be ok for subscribed_user' do
      sign_in subscribed_user
      request.env["HTTP_REFERER"] = edit_user_registration_path
      get :change_payment
      expect(response).to render_template 'brain_tree/change_payment'
    end

    scenario 'should be redirected for unsubscribed_user' do
      sign_in unsubscribed_user
      get :change_payment
      expect(response).to redirect_to billing_path
    end

    scenario 'should be redirected unsubscribed_user after last billing date' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        sign_in unsubscribed_user
        request.env["HTTP_REFERER"] = edit_user_registration_path
        get :change_payment
        expect(response).to redirect_to billing_path
      end
    end

    scenario 'should be denied access for all unconfirmed/pending_reconfirmation users' do
      sign_in unconfirmed_user
      get :change_payment
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path

      sign_in pending_reconfirmation_user
      get :change_payment
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path
    end

  end

  feature 'GET payment_history' do

    scenario 'should be redirected yet_to_subscribe_user' do
      sign_in yet_to_subscribe_user
      request.env["HTTP_REFERER"] = edit_user_registration_path
      get :payment_history
      expect(response).to redirect_to billing_path
    end

    scenario 'should be ok for subscribed_user' do
      sign_in subscribed_user
      request.env["HTTP_REFERER"] = edit_user_registration_path
      get :payment_history
      expect(response).to render_template 'brain_tree/payment_history'
    end

    scenario 'should be ok for unsubscribed_user' do
      sign_in unsubscribed_user
      get :payment_history
      expect(response).to render_template 'brain_tree/payment_history'
    end

    scenario 'should be ok for unsubscribed_user after last billing date' do
      Timecop.freeze(unsubscribed_user.next_billing_date) do
        sign_in unsubscribed_user
        request.env["HTTP_REFERER"] = edit_user_registration_path
        get :payment_history
        expect(response).to render_template 'brain_tree/payment_history'
      end
    end

    scenario 'should be denied access for all unconfirmed/pending_reconfirmation users' do
      sign_in unconfirmed_user
      get :change_payment
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path

      sign_in pending_reconfirmation_user
      get :change_payment
      expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
      expect(response).to redirect_to new_user_confirmation_path
    end

  end

  feature 'POST create_payment' do

    feature 'yet_to_subscribe_user' do
    
      before :each do
        sign_in yet_to_subscribe_user
        request.env["HTTP_REFERER"] = edit_user_registration_path
      end

      feature 'with valid nonce' do

        scenario 'should redirect_to billing_path' do
          post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce', plan: 'one_month_plan'}
          expect(response).to redirect_to billing_path
        end

        scenario 'should give user braintree_subscription_id' do
          expect(yet_to_subscribe_user.braintree_subscription_id).to eq nil
          post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce', plan: 'one_month_plan'}
          expect(yet_to_subscribe_user.reload.braintree_subscription_id).not_to eq nil
        end

        scenario 'should give user default_payment_method_token' do
          expect(yet_to_subscribe_user.default_payment_method_token).to eq nil
          post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce', plan: 'one_month_plan'}
          expect(yet_to_subscribe_user.reload.default_payment_method_token).not_to eq nil
        end

      end

      feature 'with invalid nonce' do

        scenario 'should redirect back to back' do
          post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
          expect(response).to redirect_to edit_user_registration_path
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

    feature 'subscribed_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in subscribed_user
      end

      scenario 'should redirect_to billing_path' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(response).to redirect_to billing_path
        expect(response.request.flash.alert).to eq "You are not authorized to view this page."
      end

    end

    feature 'unsubscribed_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in unsubscribed_user
      end

      scenario 'should not redirect_to billing_path' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(response).to redirect_to billing_path
        expect(response.request.flash.alert).to eq "You are not authorized to view this page."
      end

    end

    feature 'unconfirmed_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in unconfirmed_user
      end

      scenario 'should be redirect_to new_user_confirmation_path' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
      end

    end

    feature 'pending_reconfirmation_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in pending_reconfirmation_user
      end

      scenario 'should be redirect_to new_user_confirmation_path' do
        post :create_payment, { payment_method_nonce: 'fake-processor-declined-visa-nonce'}
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
      end

    end

  end

  feature 'POST update_payment' do

    feature 'yet_to_subscribe_user' do

      before :each do
        sign_in yet_to_subscribe_user
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce', plan: 'one_month_plan'}
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

          scenario 'should redirect back to change_payment_path' do
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

    feature 'unconfirmed_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in unconfirmed_user
      end

      scenario 'should be redirect_to new_user_confirmation_path' do
        post :update_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
      end

    end

    feature 'pending_reconfirmation_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in pending_reconfirmation_user
      end
      
      scenario 'should be redirect_to new_user_confirmation_path' do
        post :update_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce'}
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
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
        request.env["HTTP_REFERER"] = edit_user_registration_path
      end

      scenario 'should redirect_to billing_path' do
        post :unsubscribe
        expect(response).to redirect_to billing_path
      end

    end

    feature 'unsubscribed_user' do

      before :each do
        sign_in unsubscribed_user
        post :create_payment, { payment_method_nonce: 'fake-valid-mastercard-nonce', plan: 'one_month_plan'}
        request.env["HTTP_REFERER"] = edit_user_registration_path
      end

      scenario 'should redirect_to billing_path' do
        post :unsubscribe
        expect(response).to redirect_to billing_path
      end

      scenario 'should redirect_to billing_path even after billing date' do
        Timecop.freeze(unsubscribed_user.next_billing_date) do
          post :unsubscribe
          expect(response).to redirect_to billing_path
        end
      end

    end

    feature 'unconfirmed_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in unconfirmed_user
      end

      scenario 'should be redirect_to new_user_confirmation_path' do
        post :unsubscribe
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
      end

    end

    feature 'pending_reconfirmation_user' do

      before :each do
        request.env["HTTP_REFERER"] = edit_user_registration_path
        sign_in pending_reconfirmation_user
      end

      scenario 'should be redirect_to new_user_confirmation_path' do
        post :unsubscribe
        expect(response.request.flash['warning']).to eq "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        expect(response).to redirect_to new_user_confirmation_path
      end

    end

  end

end