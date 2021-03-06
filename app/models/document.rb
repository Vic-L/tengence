class Document < ActiveRecord::Base
  belongs_to :uploadable, polymorphic: true, touch: true

  has_attached_file :upload
  do_not_validate_attachment_file_type :upload
  validates_with AttachmentSizeValidator, attributes: :upload, less_than: 10.megabytes
end
