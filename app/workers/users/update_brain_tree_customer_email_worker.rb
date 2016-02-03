class UpdateBrainTreeCustomerEmailWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => true, :dead => false

  def perform user_id
    user = User.find(user_id)
    result = Braintree::Customer.update(
      user.braintree_customer_id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    )
    if result.success?
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "#{user.email} (#{user_id}) confirmed new email - #{user.braintree_customer_id}")
    else
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "<@vic-l> ERROR Worker\r\n#{user.email} (#{user_id}) cannot update braintree new email - #{user.braintree_customer_id}:\r\n#{result.errors.map(&:message).join("\r\n")}")
    end
  end
end