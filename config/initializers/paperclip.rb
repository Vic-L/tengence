Paperclip.interpolates :uploadable_name  do |attachment, style|
  attachment.instance.uploadable_type.pluralize.downcase
end

Paperclip.interpolates :uploadable_id  do |attachment, style|
  attachment.instance.uploadable_id.to_s
end

Paperclip::Attachment.default_options.merge!(
  storage:              :s3,
  s3_region:            ENV['AWS_S3_REGION'],
  s3_host_name:         ENV['AWS_S3_HOST_NAME'],
  s3_credentials:       {
    :bucket => ENV['AWS_S3_BUCKET'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  },
  s3_permissions:       'public-read',
  # s3_server_side_encryption: :aes256,
  s3_protocol:          :https,
  path:                 ':uploadable_name/:uploadable_id/:class/:style_:basename_:hash.:extension',
  hash_data:            ':class/:attachment/:id/:style/:updated_at',
  hash_secret:          'WeLoveOnePiece'
)

if Rails.env.test?
  Paperclip::Attachment.default_options.merge!(
    :path => "/tmp/paperclip/:uploadable_name/:uploadable_id/:class/:style_:basename_:hash.:extension",
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

