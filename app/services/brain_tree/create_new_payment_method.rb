class CreateNewPaymentMethod
  include Service
  include Virtus.model

  attribute :braintree_customer_id, String
  attribute :payment_method_nonce, String

  def call

    begin
      # braintree will not duplicate payment method
      result = Braintree::PaymentMethod.create(
        customer_id: braintree_customer_id,
        payment_method_nonce: payment_method_nonce,
        options: {
          verify_card: true,
          make_default: true
        }
      )

      if result.success?

        return {status: 'success', token: result.payment_method.token}

      else

        NotifyViaSlack.delay.call(content: "<@vic-l> ERROR CreateNewPaymentMethod Braintree::PaymentMethod.create\r\n#{result.errors.map(&:message).join("\r\n")}")

        return {status: 'error', message: "Error! " + result.errors.map(&:message).join("\r\n")}
      
      end
      
    rescue => e
      
      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE CreateNewPaymentMethod\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")

      return {status: 'error', message: 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.'}

    end

  end

end