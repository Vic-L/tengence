class Tender < ActiveRecord::Base
  include TenderFunctions
  self.primary_key = 'ref_no'
  has_many :watched_tenders
  has_many :users, through: :watched_tenders

  default_scope { order(published_date: :desc) } 
  validates_presence_of :buyer_name, :buyer_email, :buyer_contact_number, :published_date, :closing_datetime
end