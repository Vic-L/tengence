class UnsubscribeFromTengence
  include Service
  include Virtus.model

  attribute :user, User
  # attribute :payment_method_nonce, String

  def call

    begin

      result = Braintree::Subscription.cancel(user.braintree_subscription_id)

      if result.success?
        
        user.update!(next_billing_date: result.subscription.next_billing_date)

        NotifyViaSlack.call(channel: 'ida-hackathon', content: "#{user.email} unsubscribed")
          
        response = "flash[:success] = 'You have successfully unsubscribed from Tengence.';"
        response += "redirect_to billing_path"

      else

        NotifyViaSlack.call(content: "<@vic-l> ERROR UnsubscribeToTengence Braintree::Subscription.cancel\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'Error!\r\n#{result.errors.map(&:message).join("\r\n")}';"
        response += "redirect_to :back"

      end
      
    rescue => e
    
      response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
      response += "redirect_to :back"

      NotifyViaSlack.call(content: "<@vic-l> RESCUE SubscribeToTengence\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
    ensure
      return response
    end

  end
  
end