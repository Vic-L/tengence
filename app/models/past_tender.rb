class PastTender < ActiveRecord::Base
  self.primary_key = 'ref_no'
  after_initialize :readonly!
  paginates_per 50

  has_many :watched_tenders, foreign_key: :tender_id
  has_many :users, through: :watched_tenders

  default_scope { order(published_date: :desc) }

  def buyer_name_and_company
    "#{self.buyer_name} (#{self.buyer_company_name})"
  end
end