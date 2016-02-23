class UpdateSubscriptionWithNewPaymentMethod
  include Service
  include Virtus.model

  attribute :braintree_subscription_id, String
  attribute :payment_method_token, String
  attribute :user, User

  def call

    begin

      result = Braintree::Subscription.update(braintree_subscription_id, payment_method_token: payment_method_token)

      if result.success?

        user.update!(default_payment_method_token: payment_method_token)

        NotifyViaSlack.delay.call(content: "#{user.email} update payment method")

        return {status: 'success', message: 'You have successfully changed your default payment method'}

      else

        NotifyViaSlack.delay.call(content: "<@vic-l> ERROR UpdateSubscriptionWithNewPaymentMethod Braintree::Subscription.update\r\n#{result.errors.map(&:message).join("\r\n")}")

        return {status: 'error', message: "Error! " + result.errors.map(&:message).join("\r\n")}

      end
    
    rescue => e

      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE UpdateSubscriptionWithNewPaymentMethod\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")

      return {status: 'error', message: 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.'}

    end

  end

end