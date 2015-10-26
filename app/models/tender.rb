class Tender < ActiveRecord::Base
  has_many :watched_tenders
  has_many :users, through: :watched_tenders
end
