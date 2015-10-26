class Alerts < ApplicationMailer
  self.smtp_settings = {
    :host => ENV['MAIL_ADDRESS'],
    :port => 587,
    :user_name => ENV['MAIL_USERNAME'],
    :password => ENV['MAIL_PASSWORD']}

  default from: "Tengence <tengencesingapore@gmail.com>"
  default reply_to: "tengencesingapore@gmail.com"

  def alert_mail user_id
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Tengence Alerts #{Date.today}")
  end
end
