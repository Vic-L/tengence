namespace :emailer do
  task :schedule_send_keywords_tenders_emails => :environment do
    # new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date - 6.days).pluck(:ref_no)
    # return nil if new_tenders_ref_nos_array.blank?

    # dun send email is weekend
    if (Time.now.in_time_zone('Asia/Singapore').to_date.saturday? || Time.now.in_time_zone('Asia/Singapore').to_date.sunday?)
      NotifyViaSlack.call(content: "Give me a break its the weekend!")
      abort 'its the weekend!'
    end
    User.all.each do |user|
      begin
        NotifyViaSlack.call(content: "#{user.email} has no keywords") and next if user.keywords.blank?
        results_ref_nos = []
        user.keywords.split(",").each do |keyword|
          # get tenders for each keyword belonging to a user
          results = AwsManager.search(keyword: keyword)
          results_ref_nos << results.hits.hit.map do |result|
            result.fields["ref_no"][0]
          end
        end
        results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos

        if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
          current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos, published_date: Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).pluck(:ref_no) # get all tenders published from friday
        else
          current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
        end
        NotifyViaSlack.call(content: "#{user.email} has no tenders matching his/her keywords") and next if current_tenders_ref_nos.blank?

        AlertsMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_later!(wait: 1.hour)
        InternalMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_later

        current_tenders_ref_nos.each do |ref_no|
          WatchedTender.create(tender_id: ref_no, user_id: user.id)
        end
      rescue => e
        NotifyViaSlack.call(content: "Error in email rake for user #{user.id}\r\n\r\n#{e.message}\r\n\r\n#{e.backtrace.to_s}")
        InternalMailer.notify("Error in email rake for user #{user.id}", "#{e.message}\r\n\r\n#{e.backtrace.to_s}").deliver_now
      end
    end
  end
end
