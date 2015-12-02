class Document < ActiveRecord::Base
  belongs_to :uploadable, polymorphic: true, touch: true

  has_attached_file :upload
end
