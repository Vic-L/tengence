class CurrentTender < ActiveRecord::Base
  include TenderFunctions
  self.primary_key = 'ref_no'
  after_initialize :readonly!
  paginates_per 50

  has_many :watched_tenders, foreign_key: :tender_id
  has_many :users, through: :watched_tenders 

  default_scope { order(published_date: :desc) }
end