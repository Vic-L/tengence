module BrainTreeHelper
  def days_left time
    exhausted_time = (Time.current - time).abs
    if exhausted_time > 30.days.to_i
      "0"
    else
      "#{distance_of_time_in_words(30.days.to_i - exhausted_time)}"
    end
  end

  def next_billing_date date
    "#{Date.parse(date).strftime('%e %b %Y')}."
  end

  def billing_period subscription_details
    "#{(Date.parse(subscription_details.billing_period_start_date)).strftime('%d %b %Y')} - #{(Date.parse(subscription_details.billing_period_end_date)).strftime('%d %b %Y')}"
  end

  # def header_label user
  #   if user.yet_to_subscribe?
  #     "<label class='free-trial'>#{days_left(user.created_at)} left</label>".html_safe
  #   elsif user.can_resubscribe?
  #     "<label class='free-trial'>free</label>".html_safe
  #   elsif user.unsubscribed?
  #     "<label class='free-trial'>#{days_left(user.next_billing_date.to_time)} left</label>".html_safe
  #   end
  # end

  def subscription_rate plan
    case plan
    when 'one_month_plan'
      "$60 / month"
    when 'three_months_plan'
      "$150 / 90 days"
    when 'one_year_plan'
      "$480 / year"
    end
  end

  def plan plan
    case plan

    when "one_month_plan"

      "Monthly ($60 / Month)"

    when "three_months_plan"

      "Quarterly ($150 / 90 days)"

    when "one_year_plan"

      "Quarterly ($480 / year)"

    end

  end

end
