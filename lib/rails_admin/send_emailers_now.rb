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

              NotifyViaSlack.delay.call(content: "Give me a break its the weekend!")
              redirect_to '/admin', flash: {alert: "Give me a break its the weekend!"}

            else

              SendEmailsWorker.perform_async(@page_name.to_i)
              redirect_to '/admin', flash: {info: "Email alerts are now process asynchronously. Pray hard."}
              
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