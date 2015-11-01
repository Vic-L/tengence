class KeywordsValidator < ActiveModel::Validator
  def validate(user)
    if user.keywords
      case user.subscribed_plan
      when "free"
        user.errors[:keywords] << "can't be more than #{FREE_PLAN_KEYWORDS_LIMIT}" if user.keywords.split(",").count > FREE_PLAN_KEYWORDS_LIMIT
      when "standard"
        user.errors[:keywords] << "can't be more than #{STANDARD_PLAN_KEYWORDS_LIMIT}" if user.keywords.split(",").count > STANDARD_PLAN_KEYWORDS_LIMIT
      when "elite"
      end
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :watched_tenders
  has_many :current_tenders, through: :watched_tenders
  has_many :past_tenders, through: :watched_tenders
  validates_with KeywordsValidator

  def self.email_available?(email)
    User.find_by_email(email).blank?
  end

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