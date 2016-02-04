class TrialTender < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :tender, foreign_key: :tender_id
end