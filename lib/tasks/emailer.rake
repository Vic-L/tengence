namespace :emailer do
  task :schedule_send_keywords_tenders_emails => :environment do
    # new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date - 6.days).pluck(:ref_no)
    # return nil if new_tenders_ref_nos_array.blank?

    # dun send email is weekend

    today = Time.now.in_time_zone('Asia/Singapore').to_date
    if (today.saturday? || today.sunday?)

      NotifyViaSlack.call(content: "Give me a break its the weekend!")

    else

      if today.monday?
        SendEmailsWorker.perform_async(3)
      else
        SendEmailsWorker.perform_async(1)
      end
      
    end
    
  end

  task :send_keywords_tenders_emails_NOW => :environment do
    # new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date - 6.days).pluck(:ref_no)
    # return nil if new_tenders_ref_nos_array.blank?

    # dun send email is weekend
    if (Time.now.in_time_zone('Asia/Singapore').to_date.saturday? || Time.now.in_time_zone('Asia/Singapore').to_date.sunday?)
      NotifyViaSlack.call(content: "Give me a break its the weekend!")
      abort 'its the weekend!'
    end
    User.read_only.each do |user|
      begin
        NotifyViaSlack.call(content: "#{user.email} has no keywords") and next if user.keywords.blank?
        thinking_sphinx_ids = []
        user.keywords.split(",").each do |keyword|
          # get tenders for each keyword belonging to a user
          thinking_sphinx_ids << AwsManager.search(keyword: keyword)
        end
        thinking_sphinx_ids = thinking_sphinx_ids.flatten.compact.uniq #remove any duplicate tender ref nos

        if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
          current_tenders_ref_nos = CurrentTender.where(thinking_sphinx_id: thinking_sphinx_ids).where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).pluck(:ref_no) # get all tenders published from friday
        else
          current_tenders_ref_nos = CurrentTender.where(thinking_sphinx_id: thinking_sphinx_ids, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
        end
        NotifyViaSlack.call(content: "#{user.email} has no tenders matching his/her keywords") and next if current_tenders_ref_nos.blank?

        AlertsMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_now
        InternalMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_now

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
