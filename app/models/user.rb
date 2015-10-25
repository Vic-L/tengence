class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:name, :email, :company_name, :password, :password_confirmation)
  end
end