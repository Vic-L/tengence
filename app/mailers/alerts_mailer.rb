class AlertsMailer < ApplicationMailer
  helper BrainTreeHelper
  self.smtp_settings = {
    :address => ENV['SENDGRID_ADDRESS'],
    :port => 587,
    :domain => ENV['SENDGRID_DOMAIN'],
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => 'plain',
    :enable_starttls_auto => true}

  default from: "Tengence Team <hello@tengence.com.sg>"
  default reply_to: "hello@tengence.com.sg"

  def alert_mail user_id, ref_nos_array, tenders_count, days_ago=nil
    @user = User.find(user_id)
    @count = tenders_count
    tenders = Tender.where(ref_no: ref_nos_array)
    @gebiz_tenders = tenders.gebiz
    @non_gebiz_tenders = tenders.non_gebiz
    @inhouse_tenders = tenders.inhouse
    if days_ago
      @date = "From #{(Time.now.in_time_zone('Asia/Singapore').to_date - days_ago.days).strftime('%A %d-%m-%y')}"
    else
      if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
        @date = "From #{(Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).strftime('%A %d-%m-%y')}"
      else
        @date = "From #{(Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).strftime('%A %d-%m-%y')}"
      end
    end
    @subject = "Tengence Alerts #{@date}"
    mail(to: @user.email, subject: @subject)
      # , :'X-MC-SendAt' => (Time.now.in_time_zone('Asia/Singapore') + 8.hours).utc.strftime("%Y-%m-%d %H:%M:%S"))
  end

  def demo_email email
    ref_nos_array = CurrentTender.gebiz.first.ref_no, CurrentTender.non_gebiz.first.ref_no
    tenders = Tender.where(ref_no: ref_nos_array)
    @gebiz_tenders = tenders.gebiz
    @non_gebiz_tenders = tenders.non_gebiz
    @email = email
    @subject = "[Tengence] Demo Email"
    mail(to: @email, subject: @subject)
  end

  def subscription_ending_reminder user_id
    @user = User.find(user_id)
    mail(from: 'payments@tengence.com.sg', to: @user.email, subject: "Subscription ending in 7 days", reply_to: 'payments@tengence.com.sg')
  end

  def subscription_terminated user_id
    @user = User.find(user_id)
    mail(from: 'payments@tengence.com.sg', to: @user.email, subject: "Subscription expired", reply_to: 'payments@tengence.com.sg')
  end
end
