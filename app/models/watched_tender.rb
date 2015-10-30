class WatchedTender < ActiveRecord::Base
  belongs_to :current_tender, class_name: 'CurrentTender', foreign_key: :tender_id
  belongs_to :past_tender, class_name: 'PastTender', foreign_key: :tender_id
  belongs_to :tender, foreign_key: :tender_id
  belongs_to :user
end