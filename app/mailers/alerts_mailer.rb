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

  def alert_mail user_id, ref_nos_array, tenders_count
    @user = User.find(user_id)
    @count = tenders_count
    @tenders = Tender.where(ref_no: ref_nos_array)
    @date = Time.now.in_time_zone('Asia/Singapore').to_date.yesterday
    mail(to: @user.email, subject: "Tengence Alerts #{@date}", :'X-MC-SendAt' => (Time.now.in_time_zone('Asia/Singapore') + 8.hours).utc.strftime("%Y-%m-%d %H:%M:%S"))
  end
end
