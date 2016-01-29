module Api
  module V1
    class PagesController < ApiController
      skip_before_action :api_deny_non_logged_in_user
      before_action :api_deny_write_only_user, except: [:notify_error]
      before_action :api_deny_read_only_user, except: [:notify_error]

      def notify_error
        content = ["url: " + params[:url]]
        content << ["method: " + params[:method]]
        content << ["error: " + params[:error]]
        content << ["user: " + (current_user.try(:email) || 'non_logged_in user')]
        content << ["user agent: " + request.user_agent]
        NotifyViaSlack.call(content: "<@vic-l> ERROR\r\n#{content.join("\r\n")}")
        render :json => { :success => true }
      end

      def demo_email
        # TODO fix this dirty fix for recapthca in tests
        if params['g-recaptcha-response'].blank? && !Rails.env.test?
          render js: "alert('Please complete the captcha')"
        else
          NotifyViaSlack.call(channel: 'ida-hackathon', content: "#{params[:demo_email]} requested demo email")
          AlertsMailer.demo_email(params[:demo_email]).deliver_later
          render js: "$('#email-demo-submitted-button').slideDown();$('#demo-email-form fieldset').slideUp();"
        end
      end

      def demo_tenders
        @tenders, @current_page, @total_pages, @limit_value, @last_page, @watched_tender_ids, @results_count = GetDemoTenders.call(params: params, table: "CurrentTender")
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end