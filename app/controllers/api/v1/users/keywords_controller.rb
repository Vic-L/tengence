module Api
  module V1
    class Users::KeywordsController < ApiController
      before_action :api_deny_write_only_user

      def update
        begin
          current_user.keywords = params[:keywords]
          if current_user.valid?
            if current_user.save
              NotifyViaSlack.call(content: "#{current_user.email} updated keywords:\r\n#{current_user.keywords}")
              render :json => { :success => true }
            else
              NotifyViaSlack.call(content: "<@vic-l> ERROR updating keywords by #{current_user.email}\r\n#{current_user.errors.full_messages.to_sentence}")
              render json: current_user.errors.full_messages.to_sentence, status: 500
            end
          else
            NotifyViaSlack.call(content: "#{current_user.email} trying to be funny\r\n#{params[:keywords]}")
            render json: current_user.errors.full_messages.to_sentence, status: 400
          end
        rescue => e
          NotifyViaSlack.call(content: "<@vic-l> ERROR api/v1/users/keywords_controller.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
          render json: "Sorry there has been an error. \r\nOur developers are notified and are working on it. \r\nSorry for the inconvenience caused.", status: 500
        end

      end
    end
  end
end