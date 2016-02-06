class DestroyBraintreeCustomerWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => true, :dead => false

  def perform name, email, braintree_customer_id
    result = Braintree::Customer.delete(braintree_customer_id)
    if result.success?
      NotifyViaSlack.call(content: "Deleted User #{name} (#{email}) - #{braintree_customer_id}")
    else
      NotifyViaSlack.call(content: "<@vic-l> Braintree Error during delete #{name} (#{email}) - #{braintree_customer_id}:\r\n#{result.errors}")
    end
  end
end