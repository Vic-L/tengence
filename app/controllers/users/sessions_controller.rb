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

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(:users) || (current_user.write_only? ? post_a_tender_path : root_path)
      # if resource_or_scope.braintree_customer_id
      #   root_path
      # else
      #   upgrade_path
      # end
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
