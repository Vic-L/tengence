class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    if user_signed_in? && current_user.email == 'vljc17@gmail.com'
      Rack::MiniProfiler.authorize_request
    end
  end

  protected
    def deny_read_only_access
      if user_signed_in? && current_user.read_only?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to current_tenders_path
      end
    end

    def devise_parameter_sanitizer
      if resource_class == User
        User::ParameterSanitizer.new(User, :user, params)
      else
        super # Use the default one
      end
    end
end
