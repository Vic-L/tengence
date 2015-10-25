class CurrentTender < ActiveRecord::Base
  self.table_name = 'past_tenders'
  after_initialize :readonly!
  paginates_per 50
end