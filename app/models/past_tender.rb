class PastTender < ActiveRecord::Base
  self.table_name = 'past_tenders'
  after_initialize :readonly!
end