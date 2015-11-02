namespace :emailer do
  task :schedule_send_keywords_tenders_emails => :environment do
    # new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date - 6.days).pluck(:ref_no)
    # return nil if new_tenders_ref_nos_array.blank?
    User.all.each do |user|
      begin
        results_ref_nos = []
        NotifyViaSlack.call(content: "#{user.email} has no keywords") and next if user.keywords.blank?
        user.keywords.split(",").each do |keyword|
          # get tenders for each keyword belonging to a user
          results = AwsManager.search(keyword: keyword)
          results_ref_nos << results.hits.hit.map do |result|
            result.fields["ref_no"][0]
          end
        end
        results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
        current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
        NotifyViaSlack.call(content: "#{user.email} has no tenders matching his keywords") and next if current_tenders_ref_nos.blank?
        AlertsMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_later!(wait: 30.minutes)
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
