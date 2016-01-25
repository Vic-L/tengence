module EmailerActions
  def self.included base
    base.class_eval do
      register_instance_option :visible? do
        authorized?
      end

      # register action in root level
      register_instance_option :root? do
        true
      end

      register_instance_option :link_icon do
        'icon-envelope'
      end
      
      # You may or may not want pjax for your action
      register_instance_option :pjax? do
        false
      end

      register_instance_option :controller do
        proc do
          if params['_pjax']
            render nothing: true
          else
            if (Time.now.in_time_zone('Asia/Singapore').to_date.saturday? || Time.now.in_time_zone('Asia/Singapore').to_date.sunday?)
              NotifyViaSlack.call(content: "Give me a break its the weekend!")
              redirect_to '/admin', flash: {alert: "Give me a break its the weekend!"}
            else
              User.read_only.confirmed.each do |user|
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

                  # if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
                  #   current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos).where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).pluck(:ref_no) # get all tenders published from friday
                  # else
                  #   current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
                  # end

                  current_tenders_ref_nos = CurrentTender.where(ref_no: results_ref_nos).where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - @page_name.to_i.days).pluck(:ref_no) # tender published from x days ago based on @page_name's value which is intiated in config/locale/en.yml en > admin > actions > x_day_ago > title
                  
                  NotifyViaSlack.call(content: "#{user.email} has no tenders matching his/her keywords") and next if current_tenders_ref_nos.blank?

                  AlertsMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size,  @page_name.to_i).deliver_now
                  InternalMailer.alert_mail(user.id, current_tenders_ref_nos, current_tenders_ref_nos.size, @page_name.to_i).deliver_now

                  current_tenders_ref_nos.each do |ref_no|
                    WatchedTender.create(tender_id: ref_no, user_id: user.id)
                  end
                rescue => e
                  NotifyViaSlack.call(content: "Error in email rake for user #{user.id}\r\n\r\n#{e.message}\r\n\r\n#{e.backtrace.to_s}")
                  InternalMailer.notify("Error in email rake for user #{user.id}", "#{e.message}\r\n\r\n#{e.backtrace.to_s}").deliver_now
                end
              end
              redirect_to '/admin', flash: {success: "Alert Emails from #{@page_name} days ago have been sent to ALL users."}
            end
          end
        end
      end
    end
  end
end

module RailsAdmin
  module Config
    module Actions
      class OneDayAgo < RailsAdmin::Config::Actions::Base
        include EmailerActions
      end

      class TwoDayAgo < RailsAdmin::Config::Actions::Base
        include EmailerActions
      end

      class ThreeDayAgo < RailsAdmin::Config::Actions::Base
        include EmailerActions
      end

      class FourDayAgo < RailsAdmin::Config::Actions::Base
        include EmailerActions
      end

      class FiveDayAgo < RailsAdmin::Config::Actions::Base
        include EmailerActions
      end
    end
  end
end