class Users::ConfirmationsController < Devise::ConfirmationsController
  before_action :deny_confirmed_users, only: [:new, :create]
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      flash[:alert] = resource.errors.full_messages.to_sentence
      redirect_to new_user_session_path 
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?

      UpdateBrainTreeCustomerEmailWorker.perform_async(resource.id)
      
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      # respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
      flash.now[:error] = resource.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    # super(resource_name, resource)
    if user_signed_in?
      if current_user.read_only?
        current_tenders_path
      elsif current_user.write_only?
        current_posted_tenders_path
      end
    else
      root_path
    end
  end
end
