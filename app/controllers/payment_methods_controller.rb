class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!

  def index
    braintree_customer = Braintree::Customer.find(current_user.braintree_customer_id)
    @paypal_accounts = braintree_customer.paypal_accounts
    @credit_cards = braintree_customer.credit_cards
  end
  
  def new
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def create
    result = Braintree::PaymentMethod.create(
      customer_id: current_user.braintree_customer_id,
      payment_method_nonce: payment_method_params['payment_method_nonce'],
      billing_address: {
        country_code_alpha2: 'SGP',
        company_name: payment_method_params['company_name']

      },
      options: {
        verify_card: true
      }
    )
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
