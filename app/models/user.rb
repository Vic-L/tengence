class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :watched_tenders
  has_many :current_tenders, through: :watched_tenders
  has_many :past_tenders, through: :watched_tenders

  def name
    "#{first_name} #{last_name}"
  end
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def account_update
    default_params.permit(:first_name, :last_name, :email, :company_name, :password, :password_confirmation)
  end

  def sign_up
    default_params.permit(:first_name, :last_name, :email, :company_name, :password, :password_confirmation)
  end
  
  def sign_in
    default_params.permit(:email, :password)
  end
end