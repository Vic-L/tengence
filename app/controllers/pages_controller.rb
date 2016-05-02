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

  # Phase 2
  
  def landscaping
    @title = "Singapore Landscaping Services | Singapore Landscaping Companies"
    @description = "With more than 30 Landscaping vendors on our platform, get fast and easy quotations for all your Landscaping needs."
  end

  def security
    @title = "Singapore Security Services | Singapore Security Companies"
    @description = "With more than 20 Security Services vendors on our platform, get fast and easy quotations for all your Security needs."
  end

  def pest_control
    @title = "Singapore Pest Control Services | Singapore Pest Control Companies"
    @description = "With more than 40 Pest Control vendors on our platform, get fast and easy quotations for all your Pest Control needs."
  end

  def swimming_pool
    @title = "Singapore Swimming Pool Maintenance Services | Singapore Swimming Pool Maintenance Companies"
    @description = "With more than 30 Swimming Pool Maintenance vendors on our platform, get fast and easy quotations for all your Swimming Pool Maintenace needs."
  end

  def commerical_cleaning
    @title = "Singapore Commerical Cleaning Services | Singapore Commerical Cleaning Companies"
    @description = "With more than 35 Commerical Cleaning vendors on our platform, get fast and easy quotations for all your Commerical Cleaning needs."
  end

  def cctv
    @title = "Singapore CCTV Services | Singapore CCTV Companies"
    @description = "With more than 15 CCTV vendors on our platform, get fast and easy quotations for all your CCTV needs."
  end

  def gates_barriers
    @title = "Singapore Gates & Barriers Services | Singapore Gates & Barrier Companies"
    @description = "With more than 30 Gates & Barriers vendors on our platform, get fast and easy quotations for all your Gates & Barriers needs."
  end

  def gym_contractors
    @title = "Singapore Gym Maintenance Services | Singapore Gym Maintenance Companies"
    @description = "With more than 30 Gym Maintenance vendors on our platform, get fast and easy quotations for all your Gym Maintenance needs."
  end

  def private_investigators
    @title = "Singapore Private Investigator Services | Singapore Private Investigator Companies"
    @description = "With more than 30 Private Investigators vendors on our platform, get fast and easy quotations for all your Private Investigating needs."
  end

  def office_renovation_interior_design
    @title = "Singapore Office Interior Design & Renovation Services | Singapore Office Interior Design & Renovation Companies"
    @description = "With more than 20 Office Renovation Contractors on our platform, get fast and easy quotations for all your Office Renovation Contractors needs."
  end

  def events_management
    @title = "Singapore Events Management Services | Singapore Events Management Companies"
    @description = "With more than 30 Events Management vendors on our platform, get fast and easy quotations for all your Events Management needs."
  end

  def catering
    @title = "Singapore Catering Services | Singapore Catering Companies"
    @description = "With more than 30 Catering vendors on our platform, get fast and easy quotations for all your Catering needs."
  end

  def printing
    @title = "Singapore Printing Services | Singapore Printing Companies"
    @description = "With more than 80 Printing vendors on our platform, get fast and easy quotations for all your Printing needs."
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
