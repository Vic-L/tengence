class PagesController < ApplicationController
  before_action :authenticate_current_user, only: [:home]
  before_action :deny_read_only_access, only: [:post_a_tender]

  def home
  end

  def post_a_tender
  end

  def contact_us_email
    name = params[:name]
    email = params[:email]
    comments = params[:comments]
    if name.blank? || email.blank? || comments.blank?
      @message = "Please fill up all fields."
    else
      subject = "#{name} (#{email}) contacted us"
      InternalMailer.notify(subject,"Comments: #{comments}").deliver_later
      NotifyViaSlack.call(channel: "ida-hackathon", content: "#{subject}\r\n#{comments}")
      @message = "We have received your email. The Tengence team will contact you shortly."
      @message = "<div id='success_page'>"
      @message += "<h1 class='success-message'>Email Sent Successfully.</h1>"
      @message += "<p>Thank you <strong>#{name}</strong>, your message has been submitted to us.</p>"
      @message += "<p>The Tengence team will contact you shortly.</p>"
      @message += "</div>"
    end
    render json: @message.to_json
  end

  private
    def authenticate_current_user
      if user_signed_in?
        redirect_to current_tenders_path
      end
    end
end
