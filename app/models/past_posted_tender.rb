class PastPostedTender < ActiveRecord::Base
  include TenderFunctions
  self.primary_key = 'ref_no'
  after_initialize :readonly!
  paginates_per 50

  has_many :watched_tenders, foreign_key: :tender_id
  has_many :users, through: :watched_tenders 
  belongs_to :postee, class_name: 'User', foreign_key: "postee_id"

  default_scope { order(published_date: :desc) }
end
