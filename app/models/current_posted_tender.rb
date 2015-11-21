class CurrentPostedTender < ActiveRecord::Base
  include TenderFunctions
  self.primary_key = 'ref_no'
end
