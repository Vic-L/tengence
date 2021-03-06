class KeywordsValidator < ActiveModel::Validator
  def validate(user)
    if user.keywords
      unless ENV['UNLIMITED_KEYWORDS_USERS'].split(',').include? user.email
        user.errors[:keywords] << "can't be more than 20" if user.keywords.split(",").count > 20
      end
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :confirmable

  has_many :watched_tenders, dependent: :destroy
  has_many :viewed_tenders, dependent: :destroy
  has_many :current_tenders, through: :watched_tenders
  has_many :past_tenders, through: :watched_tenders
  has_many :current_posted_tenders, foreign_key: "postee_id"
  has_many :past_posted_tenders, foreign_key: "postee_id"
  has_many :trial_tenders, dependent: :destroy
  validates_with KeywordsValidator
  validates_presence_of :first_name, :last_name # , :email -> email already validated by devise

  scope :confirmed, -> { where("confirmed_at IS NOT NULL AND (unconfirmed_email IS NULL OR unconfirmed_email = '')") }
  scope :read_only, -> { where(access_level: 'read_only') }
  scope :write_only, -> { where(access_level: 'write_only') }
  scope :subscribed, -> { where.not(subscribed_plan: 'free_plan', default_payment_method_token: nil, next_billing_date: nil) }
  scope :billed_today, -> { where(next_billing_date: Time.now.in_time_zone('Singapore').to_date) }
  scope :billed_in_7_days, -> { where(next_billing_date: Time.now.in_time_zone('Singapore').to_date + 7.days) }

  before_create :hash_email
  after_commit :register_braintree_customer, on: :create, if: :read_only?
  before_destroy :destroy_braintree_customer, if: :read_only?
  after_update :send_password_change_email, if: :needs_password_change_email?

  def self.email_available?(email)
    User.find_by_email(email).blank?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def yet_to_subscribe?
    default_payment_method_token.blank? || next_billing_date.nil? # can have default_payment_method_token with no next_billing_date
  end

  def trial?
    yet_to_subscribe? && (Time.current - created_at) < 1.month.to_i
   end

  def finished_trial_but_yet_to_subscribe?
    yet_to_subscribe? && (Time.current - created_at) >= 1.month.to_i
  end

  def subscribed?
    !default_payment_method_token.blank? && subscribed_plan != "free_plan" && !next_billing_date.nil?
  end

  # NOTE: next_billing_date will never become nil once it is init with a value

  def unsubscribed?
    !default_payment_method_token.blank? && subscribed_plan == "free_plan" && !next_billing_date.nil?
  end

  def unsubscribed_and_yet_to_finish_cycle?
     unsubscribed? && Time.now.in_time_zone('Singapore').to_date < next_billing_date
  end

  def unsubscribed_and_finished_cycle?
    unsubscribed? && Time.now.in_time_zone('Singapore').to_date >= next_billing_date
  end

  def fully_confirmed?
    confirmed? && !pending_reconfirmation?
  end

  def trial_tender_ids
    trial_tenders.pluck(:tender_id)
  end

  def braintree
    Braintree::Customer.find(self.braintree_customer_id)
  end

  def write_only?
    access_level == 'write_only'
  end

  def read_only?
    access_level == 'read_only'
  end

  def god_user?
    email == ENV['GOD_USER']
  end

  def braintree_payment_methods
    braintree.payment_methods
  end

  # def braintree_subscription
  #   Braintree::Subscription.find(braintree_subscription_id)
  # end

  def register_braintree_customer
    CreateBraintreeCustomerWorker.perform_async(self.id)
  end

  def destroy_braintree_customer
    DestroyBraintreeCustomerWorker.perform_async(self.name, self.email, self.braintree_customer_id)
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

    def needs_password_change_email?
      encrypted_password_changed? && persisted?
    end
    
    def send_password_change_email
      CustomDeviseMailer.password_changed(id).deliver_later
    end
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def account_update
    default_params.permit(:first_name, :last_name, :email, :company_name, :password, :password_confirmation, :access_level)
  end

  def sign_up
    default_params.permit(:first_name, :last_name, :email, :company_name, :password, :password_confirmation, :access_level)
  end
  
  def sign_in
    default_params.permit(:email, :password, :remember_me, :access_level)
  end
end