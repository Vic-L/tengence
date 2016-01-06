module Api
  module V1
    class PagesController < ApplicationController
      respond_to :json

      def notify_error
        content = ["url: " + params[:url]]
        content << ["method: " + params[:method]]
        content << ["error: " + params[:error]]
        content << ["user: " + current_user.email]
        NotifyViaSlack.call(content: "<@vic-l> ERROR\r\n#{content.join("\r\n")}")
        render :json => { :success => true }
      end
    end
  end
end