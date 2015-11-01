class Tender < ActiveRecord::Base
  self.primary_key = 'ref_no'
  has_many :watched_tenders
  has_many :users, through: :watched_tenders

  default_scope { order(closing_datetime: :desc) } 

  def is_gebiz?
    !!(self.external_link =~ /gebiz.gov/)
  end
end