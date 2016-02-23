class CreateSubscription
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_token, String
  attribute :plan, String

  def call

    begin

      result = Braintree::Subscription.create(
          :payment_method_token => payment_method_token,
          :plan_id => plan
        )

      if result.success?

        NotifyViaSlack.delay.call(content: "#{user.email} subscribed")
        
        user.update!(
          braintree_subscription_id: result.subscription.id,
          default_payment_method_token: result.subscription.payment_method_token,
          next_billing_date: nil)

        return {status: 'success', message: 'You have successfully subscribed to Tengence. Welcome to the community.'}

      else

        NotifyViaSlack.delay.call(content: "<@vic-l> ERROR CreateSubscription Braintree::Subscription.create\r\n#{result.errors.map(&:message).join("\r\n")}")

        return {status: 'error', message: result.errors.map(&:message).join("\r\n")}

      end
      
    rescue => e
      
      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE CreateSubscription\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
      return {status: 'error', message: 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.'}

    end

  end

end