class Users::KeywordsController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.keywords = params[:keywords]
    if current_user.valid?
      if current_user.save
        flash[:success] = "Your keywords are updated"
        cookies.delete(:keywords)
        redirect_to keywords_user_path
      else
        flash[:alert] = "Error in updating keywords. Our team are onto this. Sorry for the inconvenience caused"
        cookies[:keywords] = params[:keywords]
        # internal mailer
        redirect_to keywords_user_path
      end
    else
      flash[:alert] = "Too many keywords"
      cookies[:keywords] = params[:keywords]
      # internal mailer
      redirect_to keywords_user_path
    end
  end
end
