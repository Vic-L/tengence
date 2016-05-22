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
        next unless user.god_user?
      end

      begin

        if user.keywords.blank?
          no_keywords << user.email
          next
        else
        
          results_ref_nos = []
          user.keywords.split(",").each do |keyword|
            # get tenders for each keyword belonging to a user
            results_ref_nos << AwsManager.search(keyword: keyword)
          end
          results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos

          current_tenders_ref_nos = validTenders.where(ref_no: results_ref_nos).pluck(:ref_no)
          overall_ref_nos << current_tenders_ref_nos
          
          if current_tenders_ref_nos.blank?
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

    overall_ref_nos.flatten!

    low_demand_tenders = validTenders.where(ref_no: overall_ref_nos.find_all{ |e| overall_ref_nos.count(e) <= 2 }.uniq).pluck(:description)

    overall_ref_nos.uniq!

    non_matching_tenders = validTenders.where.not(ref_no: overall_ref_nos).pluck(:description)

    content = ["Total Valid Tenders: #{total_valid_tenders}"]
    content += ["Total Matching Tenders: #{overall_ref_nos.count}"]
    content += ["Tenders that were not matched: #{non_matching_tenders.count}"]
    # content += ["#{non_matching_tenders.join("\r\n")}"]
    content += ["Tenders with <= 2 matches: #{low_demand_tenders.count}"]
    # content += ["#{low_demand_tenders.join("\r\n")}"]

    content += ["\r\nTotal Users: #{total_valid_users}"]
    content += ["Users without keywords: #{no_keywords.count}"]
    # content += ["#{no_keywords}\r\n"]
    content += ["Users without matches: #{no_matches.count}"]
    # content += ["#{no_matches}\r\n"]
    content += ["Users with matches: #{matches.count}"]

    NotifyViaSlack.call(content: content.join("\r\n"))

  end
end