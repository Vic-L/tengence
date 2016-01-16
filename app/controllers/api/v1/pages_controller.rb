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

      def demo_email
        NotifyViaSlack.call(channel: 'ida-hackathon', content: "#{params[:demo_email]} requested demo email")
        AlertsMailer.demo_email(params[:demo_email]).deliver_later
        render js: "alert('A demo email has been sent to #{params[:demo_email]}')"
      end
    end
  end
end