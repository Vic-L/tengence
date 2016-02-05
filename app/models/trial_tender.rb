class TrialTender < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :tender, foreign_key: :tender_id

  validates :tender_id, uniqueness: { scope: :user_id, message: "already unlocked for the day for this user" }
end