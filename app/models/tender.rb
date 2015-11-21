class Tender < ActiveRecord::Base
  include TenderFunctions
  self.primary_key = 'ref_no'
  has_many :watched_tenders
  has_many :users, through: :watched_tenders

  default_scope { order(published_date: :desc) } 
  validates_presence_of :buyer_name, :buyer_email, :buyer_contact_number, :published_date, :closing_datetime

  after_commit :add_to_cloudsearch, on: :create
  after_commit :update_cloudsearch, on: :update
  after_commit :remove_from_cloudsearch, on: :destroy

  def add_to_cloudsearch
    AddSingleTenderToCloudsearchWorker.perform_async(self.ref_no)
  end

  def update_cloudsearch
    UpdateSingleTenderInCloudsearchWorker.perform_async(self.ref_no)
  end

  def remove_from_cloudsearch
    RemoveSingleTenderFromCloudsearchWorker.perform_async(self.ref_no)
  end
end