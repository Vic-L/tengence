namespace :emailer do
  task :schedule_send_keywords_tenders_emails => :environment do
    new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
    break if new_tenders_ref_nos_array.blank?
    User.all.each do |user|
      begin
        results_ref_nos = []
        next if user.keywords.blank?
        user.keywords.split(",").each do |keyword|
          # get tenders for each keyword belonging to a user
          results = AwsManager.watched_tenders_search(keyword,new_tenders_ref_nos_array)
          results_ref_nos << results.hits.hit.map do |result|
            result.fields["ref_no"][0]
          end
        end
        results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
        next if results_ref_nos.blank?
        AlertsMailer.alert_mail(user.id, results_ref_nos, results_ref_nos.size).deliver_later!(wait: 3.minutes)
      rescue => e
        InternalMailer.notify("Error in email rake for user #{user.id}", "#{e.message}\r\n\r\n#{e.backtrace.to_s}").deliver_now
      end
    end
  end
end
