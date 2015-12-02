Paperclip.interpolates :imageable_name  do |attachment, style|
  attachment.instance.imageable_type.pluralize.downcase
end

Paperclip.interpolates :imageable_id  do |attachment, style|
  attachment.instance.imageable_id.to_s
end

Paperclip::Attachment.default_options.merge!(
  storage:              :s3,
  s3_credentials:       {
    :bucket => ENV['AWS_BUCKET'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  },
  s3_permissions:       :public_read,
  s3_server_side_encryption: :aes256,
  s3_protocol:          'https',
  path:                 ':imageable_name/:imageable_id/:class/:attachment/:style_:hash.:extension',
  hash_data:            ':class/:attachment/:id/:style/:updated_at',
  hash_secret:          'WeLoveOnePiece'
)

if Rails.env.test?
  Paperclip::Attachment.default_options.merge!(
    :path => "/tmp/paperclip/:imageable_name/:imageable_id/:class/:attachment/:style_:hash.:extension",
    :storage => :filesystem,
    :use_timestamp => false,
  )
end

# module Paperclip
#   class MediaTypeSpoofDetector
#     def type_from_file_command
#       begin
#         Paperclip.run("file", "-b --mime :file", :file => @file.path)
#       rescue Cocaine::CommandLineError
#         ""
#       end
#     end
#   end
# end

