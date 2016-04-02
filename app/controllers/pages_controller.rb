class PagesController < ApplicationController
  before_action :authenticate_current_user, only: [:home]
  before_action :deny_write_only_access, only: [:faq]
  before_action :deny_confirmed_users, only: [:welcome]

  def home
  end

  def terms_of_service
  end

  def faq
  end

  def refresh_cloudsearch
    begin
      array = []
      Tender.all.each do |tender|
        array << {
          'type': "add",
          'id': tender.ref_no,
          'fields': {
            'ref_no': tender.ref_no,
            'description': tender.description
          }
        }
      end; nil
      response = AwsManager.upload_document array.to_json
      if response.class == String
        NotifyViaSlack.delay.call(content: "<@vic-l> ERROR adding records to AWSCloudSearch!!\r\n#{response}")
      else
        NotifyViaSlack.delay.call(content: "Added all records on AWSCloudSearch")
      end
    rescue => e
      NotifyViaSlack.delay.call(content: "Error when refreshing cloudsearch:\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    ensure
      Tengence::Application.load_tasks
      Rake::Task['maintenance:refresh_cache'].reenable
      Rake::Task['maintenance:refresh_cache'].invoke
      render json: "success".to_json
    end
  end

  def contact_us_email
    name = params[:name]
    email = params[:email]
    comments = params[:comments]
    if name.blank? || email.blank? || comments.blank?
      @message = "Please fill up all fields."
    else
      subject = "#{name} (#{email}) contacted us"
      InternalMailer.notify(subject,"Comments: #{comments}", 'john@tengence.com.sg').deliver_later
      NotifyViaSlack.delay.call(content: "#{subject}\r\n#{comments}")
      @message = "We have received your email. The Tengence team will contact you shortly."
      @message = "<div id='success_page'>"
      @message += "<h1 class='success-message'>Email Sent Successfully.</h1>"
      @message += "<p>Thank you <strong>#{name}</strong>, your message has been submitted to us.</p>"
      @message += "<p>The Tengence team will contact you shortly.</p>"
      @message += "</div>"
    end
    render json: @message.to_json
  end

  def welcome
  end

  private
    def authenticate_current_user
      if user_signed_in?
        if current_user.read_only?
          redirect_to current_tenders_path
        elsif current_user.write_only?
          redirect_to current_posted_tenders_path
        end
      end
    end
end
