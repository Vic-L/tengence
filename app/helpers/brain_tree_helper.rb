module BrainTreeHelper
  def days_left time
    exhausted_days = Time.now - time
    if exhausted_days > 30.days
      "0"
    else
      "#{distance_of_time_in_words(30.days - exhausted_days)}"
    end
  end

  def pre_payment_accouncement plan
    html = "You are subscribing for #{plan.titleize} Plan.<br>"
    case plan
    when 'standard'
      html += "40 USD / month<br><br>"
    when 'elite'
      html += "80 USD / month<br><br>"
    end
    html.html_safe
  end

  def next_billing_date date
    "#{Date.parse(date).strftime('%e %b %Y')}."
  end
end
