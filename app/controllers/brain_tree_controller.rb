class BrainTreeController < ApplicationController
  before_action :authenticate_user!, only: [:upgrade, :checkout]

  def client_token
    if current_user
      render json: Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id).to_json
    else
      render json: Braintree::ClientToken.generate.to_json
    end
  end

  def upgrade

  end

  def checkout
    if nonce = params[:payment_method_nonce]
      if current_user.braintree_customer_id
      else
        bt_customer = Braintree::Customer.create(:first_name => current_user.first_name,:last_name => current_user.last_name,:company => current_user.company_name,:email => current_user.email,:payment_method_nonce => nonce)
        if bt_customer.success?
          # if is an upgrade from free
          if current_user.subscribed_plan == 'free'
            transaction = Braintree::Transaction.sale(:amount => params[:subscribed_plan] == 'standard' ? "40.00" : "80.00",:customer_id => bt_customer.customer.id,:options => {:submit_for_settlement => true})
            if transaction.success?
              current_user.update(braintree_customer_id: bt_customer.customer.id, subscribed_plan: params[:subscribed_plan])
              flash[:success] = "Thank you for subscribing with Tengence. Your next billing cycle will be on #{(Date.today + 30.days).strftime('%a, %d %b %Y')}."
            else
              flash[:error] = "Errors: " + transaction.errors.map{|e| e.message }.join(" ")
            end
          else
            # if is an upgrade from paid
            current_user.update(braintree_customer_id: bt_customer.customer.id, subscribed_plan: params[:subscribed_plan])
            flash[:success] = "Thank you for subscribing with Tengence. Your next billing cycle will be on #{(Date.today + 30.days).strftime('%az, %d %b %Y')}."
          end
        else
          flash[:error] = "Errors: " + bt_customer.errors.map{|e| e.message }.join(" ")
          redirect_to :back
        end
      end
    else
      flash[:error] = "Payment failed. Please try again."
    end
  end
end
