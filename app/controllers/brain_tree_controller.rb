class BrainTreeController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_subscribed_user, only: [:subscribe]

  def billing
  end

  def subscribe
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def edit_payment
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def update_payment
  end

  def create_payment
    # braintree will not duplicate payment method
    result = Braintree::PaymentMethod.create(
      customer_id: current_user.braintree_customer_id,
      payment_method_nonce: params['payment_method_nonce'],
      options: {
        verify_card: true,
        make_default: true
      }
    )
    if result.success?
      result = Braintree::Subscription.create(
        :payment_method_token => result.payment_method.token,
        :plan_id => "standard_plan",
        # :merchant_account_id => "gbp_account"
      )
      if result.success?
        flash[:success] = "You have successfully subscribed to Tengence. Welcome to the community."
        current_user.update(braintree_subscription_id: result.subscription.id)
        redirect_to billing_path
      else
        flash[:alert] = "An error occurred. Our developers are notified and are currently working on it. Thank you for your patience."
        NotifyViaSlack.call(content: "<@vic-l> ERROR in braintree payment methods\r\n#{result}")
        redirect_to :back
      end
    else
      flash[:alert] = "An error occurred. Our developers are notified and are currently working on it. Thank you for your patience."
      NotifyViaSlack.call(content: "<@vic-l> ERROR in braintree payment methods\r\n#{result}")
      redirect_to :back
    end
  end

  private
    def deny_subscribed_user
      redirect_to :billing if current_user.braintree_subscription_id
    end
end
