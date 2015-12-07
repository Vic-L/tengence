class Tender < ActiveRecord::Base
  strip_attributes
  include TenderFunctions
  self.primary_key = 'ref_no'

  has_many :watched_tenders, dependent: :destroy
  has_many :users, through: :watched_tenders
  
  has_many :documents, as: :uploadable, dependent: :destroy
  accepts_nested_attributes_for :documents, :reject_if => lambda { |t| t['upload'].nil? }, allow_destroy: true

  default_scope { order(published_date: :desc) } 
  validates_presence_of :buyer_name, :buyer_email, :buyer_contact_number, :published_date, :closing_datetime

  after_commit :add_to_cloudsearch, on: :create
  before_update :update_cloudsearch, on: :update
  after_commit :remove_from_cloudsearch, on: :destroy

  def add_to_cloudsearch
    AddSingleTenderToCloudsearchWorker.perform_async(self.ref_no, self.description)
  end

  def update_cloudsearch
    UpdateSingleTenderInCloudsearchWorker.perform_async(self.ref_no, self.description) if self.description_changed?
  end

  def remove_from_cloudsearch
    RemoveSingleTenderFromCloudsearchWorker.perform_async(self.ref_no, self.description)
  end

  rails_admin do
    edit do
      field :ref_no
      field :buyer_company_name
      field :buyer_name
      field :buyer_contact_number
      field :buyer_email
      field :description
      field :published_date
      field :closing_datetime
      field :external_link do
        help 'Leave BLANK for INHOUSE tenders'
      end
      field :status  do
        help 'open; expired; cancelled'
      end
      field :category
      field :remarks
      field :budget do
        help 'Leave BLANK for SCRAPED tenders'
      end
      field :postee_id do
        help 'Leave BLANK for SCRAPED tenders; id of user who posting'
      end
      field :long_description do
        help 'Leave BLANK for SCRAPED tenders'
      end
    end
  end
end