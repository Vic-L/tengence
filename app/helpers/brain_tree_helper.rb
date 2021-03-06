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

  def subscription_rate plan
    case plan
    when 'one_month_plan'
      "$59 / month"
    when 'three_months_plan'
      "$147 / 90 days"
    when 'one_year_plan'
      "$468 / year"
    end
  end

  def transaction_amount plan
    case plan
    when 'one_month_plan'
      "$59"
    when 'three_months_plan'
      "$147"
    when 'one_year_plan'
      "$468"
    end
  end

  def plan plan
    case plan
    when "one_month_plan"
      "Monthly ($59 / Month)"
    when "three_months_plan"
      "Quarterly ($147 / 90 days)"
    when "one_year_plan"
      "Annually ($468 / year)"
    end
  end

  def plan_next_billing_date plan
    case plan
    when "one_month_plan"
      (Time.now.in_time_zone('Asia/Singapore').to_date + 30.days).strftime('%e %b %Y')
    when "three_months_plan"
      (Time.now.in_time_zone('Asia/Singapore').to_date + 90.days).strftime('%e %b %Y')
    when "one_year_plan"
      (Time.now.in_time_zone('Asia/Singapore').to_date + 1.year).strftime('%e %b %Y')
    end
  end

end
