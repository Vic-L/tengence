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
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :watched_tenders, dependent: :destroy
  has_many :viewed_tenders, dependent: :destroy
  has_many :current_tenders, through: :watched_tenders
  has_many :past_tenders, through: :watched_tenders
  has_many :current_posted_tenders, foreign_key: "postee_id"
  has_many :past_posted_tenders, foreign_key: "postee_id"
  validates_with KeywordsValidator

  include AASM
  aasm column: :access_level do
    state :read_only, :initial => true
    state :write_only
  end

  before_validation :create_braintree_customer, on: :create
  before_destroy :delete_braintree_customer
  before_create :hash_email

  def self.email_available?(email)
    User.find_by_email(email).blank?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def braintree
    Braintree::Customer.find(self.braintree_customer_id)
  end

  def braintree_payment_methods
    braintree.payment_methods
  end

  def braintree_subscriptions
    hash = {}
    braintree.payment_methods.each{|pm| hash[pm] = pm.subscriptions}
    hash
  end

  def create_braintree_customer
    result = Braintree::Customer.create(
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      company: self.company_name
    )
    if result.success?
      self.braintree_customer_id = result.customer.id
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "New User #{self.name} (#{self.email}) - #{self.braintree_customer_id}")
    else
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "<@vic-l> Braintree Error during delete #{self.name} (#{self.email}) - #{self.braintree_customer_id}:\r\n#{result.errors}")
    end
  end

  def delete_braintree_customer
    result = Braintree::Customer.delete(self.braintree_customer_id)
    if result.success?
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "Deleted User #{self.name} (#{self.email}) - #{self.braintree_customer_id}")
    else
      NotifyViaSlack.call(channel: 'ida-hackathon', content: "<@vic-l> Braintree Error during delete #{self.name} (#{self.email}) - #{self.braintree_customer_id}:\r\n#{result.errors}")
    end
  end

  rails_admin do
    list do
      field :email
      field :keywords
      field :access_level
      field :current_sign_in_at do
        pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
          "#{(value + 8.hours).day.ordinalize} #{(value + 8.hours).strftime('%b %Y')} #{(value + 8.hours).strftime('%H:%M %p')}"
        end
      end
    end
  end

  private
    def hash_email
      self.hashed_email = Digest::SHA256.hexdigest(email)
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