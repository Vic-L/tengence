class AlertsMailer < ApplicationMailer
  self.smtp_settings = {
    :address => ENV['MAIL_ADDRESS'],
    :port => 587,
    :user_name => ENV['MAIL_USERNAME'],
    :password => ENV['MAIL_PASSWORD'],
    :authentication => 'plain',
    :enable_starttls_auto => true}

  default from: "Tengence <tengencesingapore@gmail.com>"
  default reply_to: "tengencesingapore@gmail.com"

  def alert_mail user_id
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Tengence Alerts #{Time.now.in_time_zone('Asia/Singapore').to_date.yesterday}", send_at: (Time.now.in_time_zone('Asia/Singapore') + 8.hours).utc)
  end
end
