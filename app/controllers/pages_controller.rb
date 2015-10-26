class PagesController < ActionController::Base
  layout :layout_for_page
  before_action :authenticate_current_user

  def home

  end

  private
    def layout_for_page
      case params[:id]
      when 'lol'
      else
        'application'
      end
    end

    def authenticate_current_user
      if user_signed_in?
        redirect_to current_tenders_path
      end
    end
end
