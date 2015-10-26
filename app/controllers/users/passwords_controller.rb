class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      set_flash_message(:alert, :not_found_in_database) if is_flashing_format?
      respond_with({}, location: passwords_error_path_for(resource_name))
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected
    def after_resetting_password_path_for(resource)
      current_tenders_path
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_user_session_path
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_user_session_path
      end
    end

    def passwords_error_path_for(resource_name)
      new_user_password_path
    end
end
