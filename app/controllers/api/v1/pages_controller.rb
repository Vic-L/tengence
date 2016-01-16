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
        # url = URI.parse("https://www.google.com/recaptcha/api/siteverify")
        # data = {secret: "#{ENV['RECAPTCHA_SECRET']}", response: params['g-recaptcha-response']}

        # http = Net::HTTP.new(url.host, url.port)
        # http.use_ssl = true
        # req = Net::HTTP::Post.new(url.path, {'Content-Type' =>'application/json'})
        # req.body = data.to_json
        # resp = http.request(req)

        if params['g-recaptcha-response'].blank?
          render js: "alert('Please complete the captcha')"
        else
          NotifyViaSlack.call(channel: 'ida-hackathon', content: "#{params[:demo_email]} requested demo email")
          AlertsMailer.demo_email(params[:demo_email]).deliver_later
          render js: "$('#email-demo-submitted-button').slideDown();$('#demo-email-form fieldset').slideUp();"
        end

        # if JSON.parse(resp.body)['success']
        #   AlertsMailer.demo_email(params[:demo_email]).deliver_later
        #   render js: "alert('A demo email has been sent to #{params[:demo_email]}')"
        # else
        #   render js: "alert('Your email is invalid.')"
        # end
      end
    end
  end
end