class UpdateSubscriptionWithNewPaymentMethod
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_nonce, String

  def call

    begin
      result = Braintree::PaymentMethod.create(
        customer_id: user.braintree_customer_id,
        payment_method_nonce: payment_method_nonce,
        options: {
          verify_card: true,
          make_default: true
        }
      )

      if result.success?

        payment_method_token = result.payment_method.token
        result = Braintree::Subscription.update(user.braintree_subscription_id, payment_method_token: payment_method_token)

        if result.success?

          user.update!(default_payment_method_token: payment_method_token)


          response = "flash[:success] = 'You have successfully change your default payment method';"
          response += "redirect_to billing_path"

        else

          NotifyViaSlack.call(content: "<@vic-l> ERROR UpdateSubscriptionWithNewPaymentMethod Braintree::Subscription.update\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
        response += "redirect_to :back"

        end
      
      else

        NotifyViaSlack.call(content: "<@vic-l> ERROR UpdateSubscriptionWithNewPaymentMethod Braintree::PaymentMethod.create\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
        response += "redirect_to :back"
      
      end
    
    rescue => e
    
      response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
      response += "redirect_to :back"

      NotifyViaSlack.call(content: "<@vic-l> RESCUE UpdateSubscriptionWithNewPaymentMethod\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
    ensure
      return response
    end

  end
end