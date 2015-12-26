class UpdateDefaultPaymentMethod
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_token, String

  def call

    begin

      result = Braintree::PaymentMethod.update(
        payment_method_token,
        :options => {
          :make_default => true
        }
      )

      if result.success?

        user.update!(default_payment_method_token: payment_method_token)

        response = "flash[:success] = 'You have successfully change your default payment method';"
        response += "redirect_to billing_path"

      else
        
        NotifyViaSlack.call(content: "<@vic-l> ERROR UpdateDefaultPaymentMethod Braintree::PaymentMethod.update\r\n#{result.errors.map(&:message).join("\r\n")}")

        response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
        response += "redirect_to :back"
        
      end
    
    rescue => e
    
      response = "flash[:alert] = 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.';"
      response += "redirect_to :back"

      NotifyViaSlack.call(content: "<@vic-l> RESCUE UpdateDefaultPaymentMethod\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
    ensure
      return response
    end

  end
end