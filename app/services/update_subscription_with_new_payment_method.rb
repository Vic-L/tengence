class UpdateSubscriptionWithNewPaymentMethod
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_nonce, String

  def call

    begin

      result = Braintree::Subscription.update(user.braintree_subscription_id, payment_method_nonce: payment_method_nonce)

      if result.success?

        response = UpdateDefaultPaymentMethod.call(
          user: user,
          payment_method_token: result.subscription.payment_method_token)
      
      else

        NotifyViaSlack.call(content: "<@vic-l> ERROR UpdateSubscriptionWithNewPaymentMethod Braintree::Subscription.update\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
        response += "redirect_to :back"
      
      end
    
    rescue => e
    
      response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
      response += "redirect_to :back"

      NotifyViaSlack.call(content: "<@vic-l> RESCUE UpdateSubscriptionWithNewPaymentMethod\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
    ensure
      return response
    end

  end
end