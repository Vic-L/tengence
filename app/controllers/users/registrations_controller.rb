class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def check_email_taken
    # the jquery validate plugin expects true for valid parameters
    email_wrapper = params[:user]
    rv = User.email_available?(email_wrapper[:email])
    render json: rv.to_json
  end

  protected
    def update_resource(resource, params)
      if params['password'].blank?
        resource.update_without_password(params)
      else
        resource.update(params)
        # resource.update_with_password(params) # use this if require current password
      end
    end

    def after_update_path_for(resource)
      edit_user_registration_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.for(:sign_up) << :attribute
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.for(:account_update) << :attribute
    # end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      # upgrade_path
      current_tenders_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
end
