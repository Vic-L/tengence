class BrainTreeController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_subscribed_user, only: [:subscribe]

  def billing
    if current_user.braintree_subscription_id
      @payment_method = current_user.braintree_subscription.payment_method_token
    end
  end

  def subscribe
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def edit_payment
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    @payment_method = current_user.braintree_subscription.payment_method_token
  end

  def update_payment
    resp = UpdateSubscriptionWithNewPaymentMethod.call(
      user: current_user,
      payment_method_nonce: params['payment_method_nonce'])
    
    eval(resp)
  end

  def create_payment
    resp = SubscribeToTengence.call(
      user: current_user,
      payment_method_nonce: params['payment_method_nonce']
      )
    eval(resp)
  end

  private
    def deny_subscribed_user
      redirect_to :billing if !current_user.braintree_subscription_id.blank?
    end
end
