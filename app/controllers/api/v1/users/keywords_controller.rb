module Api
  module V1
    class Users::KeywordsController < ApplicationController
      respond_to :json

      def update
        begin
          current_user.keywords = params[:keywords]
          if current_user.valid?
            if current_user.save
              render :json => { :success => true }
            else
              render json: current_user.errors.full_messages.to_sentence, status: 500
            end
          else
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