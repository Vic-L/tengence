namespace :maintenance do

  task :set_thinking_sphinx_id => :environment do
    Tender.where(thinking_sphinx_id: 0).each do |tender|
      random_id = 0
      loop do
        random_id = SecureRandom.random_number(1..9999).to_i
        break random_id unless Tender.exists?(thinking_sphinx_id: random_id)
      end
      tender.update(thinking_sphinx_id: random_id)
    end
  end

  task :ping_index_complete => :environment do
    NotifyViaSlack.call(content: "updated sphinx index")
  end

  task :ping_sidekiq => :environment do
    NotifyViaSlack.call(content: "<@vic-l> Mayday! Asynchronous server 死んだ！！") if Sidekiq::ProcessSet.new.size == 0
    # NotifyViaSlack.call(content: "Sidekiq up and running") if Sidekiq::ProcessSet.new.size == 1
  end

  task :remove_trial_tenders => :environment do
    TrialTender.destroy_all
    content = "Removed all trial tenders"
    NotifyViaSlack.call(content: content)
  end

  task :cleanup_past_tenders => :environment do
    if Rails.env.production?
      t = Time.now.in_time_zone('Singapore').beginning_of_day
      t = t.utc + t.utc_offset()
      ref_nos = Tender.non_inhouse.where("closing_datetime < ?", t - 1.month).pluck(:ref_no)
      if ref_nos.blank?
        NotifyViaSlack.call(content: "No ancient tenders")
      else
        WatchedTender.where(tender_id: ref_nos).destroy_all
        Tender.where(ref_no: ref_nos).delete_all

        Tengence::Application.load_tasks
        Rake::Task['maintenance:refresh_cache'].reenable
        Rake::Task['maintenance:refresh_cache'].invoke

        # to be deleted
        array = []
        ref_nos.each do |ref_no|
          array << {
            'type': "delete",
            'id': ref_no
          }
        end; nil
        response = AwsManager.upload_document array.to_json

        if response.class == String
          NotifyViaSlack.call(content: "<@vic-l> ERROR removing ancient tenders from AWSCloudSearch!!\r\n#{response}")
        else

          NotifyViaSlack.call(content: "Removed ancient tenders")
        # end
      end
    else
      puts "execute 'rake maintenance:cleanup_past_tenders'"
    end
  end

  task :refresh_cache => :environment do
    Rails.cache.clear
    keywords = User.pluck(:keywords).flatten.compact.uniq.join(',')

    results_ref_nos = []
    keywords.split(',').each do |keyword|
      results_ref_nos << AwsManager.search(keyword: keyword.strip.downcase)
    end
    results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos

    keywords.each do |keyword|
      # get tenders for each keyword belonging to a user
      Tender.search_for_ids(keyword).to_a
    end
  end

  task :charge_users => :environment do
    User.subscribed.billed_today.each do |user|

      next if user.email == 'vljc17@gmail.com'
      next if user.email == 'john@tengence.com.sg'
      next if user.email == 'ganthertay@gmail.com'
      next if user.trial? || user.finished_trial_but_yet_to_subscribe?

      if user.auto_renew
      
        amount = ""
        next_billing_date = ""
        
        case user.subscribed_plan
        when "one_month_plan"
          amount = "59.00"
        when "three_months_plan"
          amount = "147.00"
        when "one_year_plan"
          amount = "468.00"
        else
          NotifyViaSlack.call(content: "<@vic-l> maintenance.rake User #{user.email} subscribed_plan is weird")
          next
        end

        case user.subscribed_plan
        when "one_month_plan"
          next_billing_date = Time.now.in_time_zone('Singapore').to_date + 30.days
        when "three_months_plan"
          next_billing_date = Time.now.in_time_zone('Singapore').to_date + 90.days
        when "one_year_plan"
          next_billing_date = Time.now.in_time_zone('Singapore').to_date + 1.year
        end

        result = Braintree::Transaction.sale(
          :payment_method_token => user.default_payment_method_token,
          amount: amount,
          :options => {
            :submit_for_settlement => true
          }
        )

        if result.success?

          NotifyViaSlack.call(content: "#{user.email} charged #{amount}")
          begin
            user.update!(next_billing_date: next_billing_date)
          rescue => e
            NotifyViaSlack.call(content: "<@vic-l> ERROR #{user.email} cannot update next_billing_date")
          end
        
        else

          NotifyViaSlack.call(content: "<@vic-l> ERROR #{user.email} NOT successfully charged")

        end

      else

        begin
          # users here are subscribed, billed today, but nvr put auto renew
          # so need to terminate their subscription
          user.update!(subscribed_plan: 'free_plan')
          NotifyViaSlack.call(content: "#{user.email} not auto_renew and downgraded. NO EMAIL was sent to tell him abt termination")
        rescue => e
          NotifyViaSlack.call(content: "<@vic-l> ERROR #{user.email} not auto_renew but cannot downgrade subscribed_plan")
          next
        end

      end

    end

  end

  task :subscription_ending_reminder => :environment do
    User.subscribed.billed_in_7_days.each do |user|
      NotifyViaSlack.call(content: "Emailed #{user.email} subscription_ending_reminder")
      AlertsMailer.subscription_ending_reminder(user.id).deliver_now
      InternalMailer.subscription_ending_reminder(user.id).deliver_now
    end
  end

end