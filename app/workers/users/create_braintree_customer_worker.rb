class CreateBraintreeCustomerWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => true, :dead => false

  def perform user_id
    user = User.find(user_id)
    result = Braintree::Customer.create(
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      company: user.company_name
    )
    if result.success?
      user.update!(braintree_customer_id: result.customer.id)
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "New User #{user.name} (#{user.email}) - #{user.braintree_customer_id}")
    else
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "<@vic-l> Braintree Error during delete #{user.name} (#{user.email}) - #{user.braintree_customer_id}:\r\n#{result.errors}")
    end
  end
end