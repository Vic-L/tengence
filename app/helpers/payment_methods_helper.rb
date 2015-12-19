module PaymentMethodsHelper
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
end
