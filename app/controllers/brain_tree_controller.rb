class BrainTreeController < ApplicationController
  before_action :authenticate_user!, only: [:upgrade]

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
      byebug
    if nonce = params[:payment_method_nonce]
      result = Braintree::Transaction.sale(:amount => "100.00",:payment_method_nonce => nounce)
    else
    end
  end
end
