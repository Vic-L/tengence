class SubscribeToTengence
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_nonce, String
  attribute :plan, String

  def call

    begin

      # braintree will not duplicate payment method
      result = Braintree::PaymentMethod.create(
        customer_id: user.braintree_customer_id,
        payment_method_nonce: payment_method_nonce,
        options: {
          verify_card: true,
          make_default: true
        }
      )

      if result.success?

        # user.update!(default_payment_method_token: result.payment_method.token)

        result = Braintree::Subscription.create(
          :payment_method_token => result.payment_method.token,
          :plan_id => plan
        )

        if result.success?

          NotifyViaSlack.delay.call(content: "#{user.email} subscribed")
          
          user.update!(
            braintree_subscription_id: result.subscription.id,
            default_payment_method_token: result.subscription.payment_method_token,
            next_billing_date: nil)
          
          response = "flash[:success] = 'You have successfully subscribed to Tengence. Welcome to the community.';"
          response += "redirect_to billing_path"

        else

          NotifyViaSlack.delay.call(content: "<@vic-l> ERROR SubscribeToTengence Braintree::Subscription.create\r\n#{result.errors.map(&:message).join("\r\n")}")

          response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
          response += "redirect_to :back"

        end

      else

        NotifyViaSlack.delay.call(content: "<@vic-l> ERROR SubscribeToTengence Braintree::PaymentMethod.create\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
        response += "redirect_to :back"
      
      end
      
    rescue => e
    
      response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
      response += "redirect_to :back"

      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE SubscribeToTengence\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
    ensure
      return response
    end

  end
end