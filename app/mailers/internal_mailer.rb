class InternalMailer < ApplicationMailer
  helper BrainTreeHelper
  self.delivery_method = :sendmail if (Rails.env.production? || Rails.env.staging?)

  default from: 'notification@tengence.com.sg'

  def notify subject, content, to_target="tengencesingapore@gmail.com"
    @subject, @content = subject, content
    mail(to: to_target, subject: @subject, cc: 'vljc17@gmail.com')
  end

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
    @subject = "TA #{@date} for #{@user.email}"
    mail(to: 'tengencesingapore@gmail.com', subject: @subject, template_path: 'alerts_mailer', template_name: 'alert_mail')
      # , :'X-MC-SendAt' => (Time.now.in_time_zone('Asia/Singapore') + 8.hours).utc.strftime("%Y-%m-%d %H:%M:%S"))
  end

  def subscription_ending_reminder user_id
    @user = User.find(user_id)
    mail(to: 'tengencesingapore@gmail.com', subject: "#{@user.email} subscription ending in 7 days time", cc: 'john@tengence.com.sg', template_path: 'alerts_mailer', template_name: 'subscription_ending_reminder')
  end
end