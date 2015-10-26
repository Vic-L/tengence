class CurrentTender < ActiveRecord::Base
  self.table_name = 'past_tenders'
  after_initialize :readonly!
  paginates_per 50

  def buyer_name_and_company
    "#{self.buyer_name} (#{self.buyer_company_name})"
  end
end