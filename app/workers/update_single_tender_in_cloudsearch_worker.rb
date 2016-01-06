class UpdateSingleTenderInCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform ref_no, description
    hash = {
      'type': "add",
      'id': ref_no,
      'fields': {
        'ref_no': ref_no,
        'description': description
      }
    }
    puts hash.to_s
    AwsManager.upload_document [hash].to_json
    NotifyViaSlack.call(content: "<@ganther> Tender Updated\r\nwww.tengence.com.sg/admin/tender/#{ref_no}") if Rails.env.production?
  end
end