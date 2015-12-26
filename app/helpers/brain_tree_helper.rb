module BrainTreeHelper
  def days_left time
    "<p><span id='days-left'>#{distance_of_time_in_words(Time.now - time)}</span> left</p>".html_safe
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
    "Your next billing date is #{Date.parse(date).strftime('%e %b %Y')}."
  end
end
