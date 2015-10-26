class PastTender < ActiveRecord::Base
  after_initialize :readonly!
  paginates_per 50

  has_many :watched_tenders
  has_many :users, through: :watched_tenders

  def buyer_name_and_company
    "#{self.buyer_name} (#{self.buyer_company_name})"
  end
end