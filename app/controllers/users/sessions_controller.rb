class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
  private
    # def respond_to_on_destroy
    #   render js: "window.location.href='#{root_path}'"
    # end

    def after_sign_in_path_for resource
      current_user.write_only? ? current_posted_tenders_path : stored_location_for(resource) || root_path
      # if resource.braintree_customer_id
      #   root_path
      # else
      #   upgrade_path
      # end
    end

    def after_inactive_sign_in_path_for resource
      new_user_confirmation_path(resource)
    end

    def after_sign_out_path_for resource
      root_path
    end
end
