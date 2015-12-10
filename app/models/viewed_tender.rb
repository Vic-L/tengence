class ViewedTender < ActiveRecord::Base
  belongs_to :tender, foreign_key: :ref_no
  belongs_to :user
end