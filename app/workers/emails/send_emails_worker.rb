class SendEmailsWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => false

  def perform no_of_days
    # tender published from x days ago based on no_of_days's value which is intiated in config/locale/en.yml en > admin > actions > x_day_ago > title
    validTenders = CurrentTender.where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - no_of_days.days).where("published_date < ?", Time.now.in_time_zone('Asia/Singapore').to_date)

    no_keywords = []
    no_matches = []
    matches = []
    total_valid_users = User.read_only.confirmed.count
    total_valid_tenders = validTenders.count
    overall_ref_nos = []

    User.read_only.confirmed.each do |user|
      if ENV['EMAIL_DEBUG_MODE'] == 'true'
        next unless user.email == 'vljc17@gmail.com'
      end
      begin
        if user.keywords.blank?
          
          # NotifyViaSlack.call(content: "#{user.email} has no keywords")
          no_keywords << user.email
          next
        
        else
        
          results_ref_nos = []
          user.keywords.split(",").each do |keyword|
            # get tenders for each keyword belonging to a user
            results_ref_nos << AwsManager.search(keyword: keyword)
          end
          results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos

          # if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
          #   current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos).where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).pluck(:ref_no) # get all tenders published from friday
          # else
          #   current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
          # end

          current_tenders_ref_nos = validTenders.where(ref_no: results_ref_nos).pluck(:ref_no)
          overall_ref_nos << current_tenders_ref_nos
          
          if current_tenders_ref_nos.blank?
            # NotifyViaSlack.call(content: "#{user.email} has no tenders matching his/her keywords")
            no_matches << user.email
            next
          else

            AlertsMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size, no_of_days).deliver_now
            InternalMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size, no_of_days).deliver_now

            matches << user.email

            current_tenders_ref_nos.each do |ref_no|
              WatchedTender.create(tender_id: ref_no, user_id: user.id)
            end

          end

        end
      rescue => e
        NotifyViaSlack.call(content: "Error in email rake for user #{user.id}\r\n\r\n#{e.message}\r\n\r\n#{e.backtrace.to_s}")
        InternalMailer.notify("Error in email rake for user #{user.id}", "#{e.message}\r\n\r\n#{e.backtrace.to_s}").deliver_now
      end
    end

    overall_ref_nos.flatten!.uniq!

    non_matching_tenders = validTenders.where.not(ref_no: overall_ref_nos).pluck(:description)

    NotifyViaSlack.call(content: "Total Valid Tenders: #{total_valid_tenders}\r\nTotal Matching Tenders: #{overall_ref_nos.count}\r\n\r\nTotal Users: #{total_valid_users}\r\nUsers without keywords: #{no_keywords.count}\r\n#{no_keywords}\r\nUsers without matches: #{no_matches.count}\r\n#{no_matches}\r\nUsers with matches: #{matches.count}\r\n\r\nTenders that were not matched:\r\n#{non_matching_tenders.join("\r\n")}")

  end
end