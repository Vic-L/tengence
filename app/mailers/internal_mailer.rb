class InternalMailer < ApplicationMailer
  default from: 'notification@tengence.com.sg'

  def notify subject, content, to_target="tengencesingapore@gmail.com"
    @subject, @content = subject, content
    mail(to: to_target, subject: @subject, cc: 'vljc17@gmail.com')
  end

  def alert_mail user_id, ref_nos_array, tenders_count
    @user = User.find(user_id)
    @count = tenders_count
    @tenders = Tender.where(ref_no: ref_nos_array)
    @date = Time.now.in_time_zone('Asia/Singapore').to_date.yesterday
    mail(to: 'tengencesingapore@gmail.com', subject: "TA #{@date} for #{@user.email}", template_path: 'alerts_mailer', template_name: 'alert_mail')
      # , :'X-MC-SendAt' => (Time.now.in_time_zone('Asia/Singapore') + 8.hours).utc.strftime("%Y-%m-%d %H:%M:%S"))
  end
end
