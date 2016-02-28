class UnsubscribeFromTengence
  include Service
  include Virtus.model

  attribute :user, User
  # attribute :payment_method_nonce, String

  def call

    begin
        
      user.update!(subscribed_plan: "free_plan")

      NotifyViaSlack.delay.call(content: "#{user.email} unsubscribed")

      return {status: "success", message: 'You have successfully unsubscribed from Tengence.'}
      
    rescue => e

      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE UnsubscribeFromTengence\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")

      return {status: "error", message: 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.'}
    
    end

  end
  
end