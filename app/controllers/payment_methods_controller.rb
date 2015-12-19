class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!

  def index
    braintree_customer = Braintree::Customer.find(current_user.braintree_customer_id)
    @paypal_accounts = braintree_customer.paypal_accounts
    @credit_cards = braintree_customer.credit_cards
  end
  
  def new
    @plan = params[:plan] if params[:plan]
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def create
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
        flash[:success] = "You have successfully subscribed to Tengence. Check your billing cycle <a href='#{main_app.root_path}'>here</a>. Lastly, welcome to the community.".html_safe
        redirect_to current_tenders_path
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
    def payment_method_params
      params.require(:payment_method).permit(
        :billing_address_id,
        :cvv,
        :cardholder_name,
        :customer_id,
        :device_data,
        :expiration_date,
        :expiration_month,
        :expiration_year,
        :number,
        billing_address: [
          :payment_method_nonce,
          :company_name,
          :extended_address,
          :first_name,
          :last_name,
          :locality,
          :postal_code,
          :region,
          :street_address
        ]
      )
    end
end
