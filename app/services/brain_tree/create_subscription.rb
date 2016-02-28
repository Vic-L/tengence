class CreateSubscription
  include Service
  include Virtus.model

  attribute :user, User
  attribute :payment_method_token, String
  attribute :plan, String
  attribute :next_billing_date, Date
  attribute :renew, Boolean

  def call

    begin

      if next_billing_date.nil? ||
        (!next_billing_date.nil? && Time.now.in_time_zone('Singapore').to_date >= next_billing_date)

        result = Braintree::Transaction.sale(
            :payment_method_token => payment_method_token,
            amount: get_amount,
            :options => {
              :submit_for_settlement => true
            }
          )

        if result.success?

          NotifyViaSlack.delay.call(content: "#{user.email} subscribed")
          
          user.update!(
            subscribed_plan: plan,
            default_payment_method_token: payment_method_token,
            next_billing_date: get_next_billing_date,
            auto_renew: renew)

          return {status: 'success', message: 'You have successfully subscribed to Tengence. Welcome to the community.'}

        else

          NotifyViaSlack.delay.call(content: "<@vic-l> ERROR CreateSubscription Braintree::Transaction.sale\r\n#{result.errors.map(&:message).join("\r\n")}")

          return {status: 'error', message: result.errors.map(&:message).join("\r\n")}

        end
        
      else

        user.update!(
          subscribed_plan: plan,
          default_payment_method_token: payment_method_token,
          auto_renew: renew)

        return {status: 'success', message: 'You have successfully subscribed to Tengence. Welcome to the community.'}

      end

    rescue => e
      
      NotifyViaSlack.delay.call(content: "<@vic-l> RESCUE CreateSubscription\r\n#{e.message.to_s}\r\n#{e.backtrace.join("\r\n")}")
    
      return {status: 'error', message: 'An error occurred. Our developers are notified and are currently working on it. Thank you for your patience.'}

    end

  end

  private

    def get_amount

      case plan

      when "one_month_plan"

        "60.00"

      when "three_months_plan"

        "150.00"

      when "one_year_plan"

        "480.00"

      end

    end

    def get_next_billing_date

      case plan

      when "one_month_plan"

        Time.now.in_time_zone('Singapore').to_date + 30.days

      when "three_months_plan"

        Time.now.in_time_zone('Singapore').to_date + 90.days

      when "one_year_plan"

        Time.now.in_time_zone('Singapore').to_date + 1.year

      end

    end

end