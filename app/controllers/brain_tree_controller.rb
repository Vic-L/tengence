class BrainTreeController < ApplicationController
  def client_token
    render json: Braintree::ClientToken.generate.to_json
  end
end
