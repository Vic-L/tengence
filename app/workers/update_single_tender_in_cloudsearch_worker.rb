class UpdateSingleTenderInCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform ref_no
    tender = Tender.find(ref_no)
    hash = {
      'type': "delete",
      'id': tender.ref_no
    }
    AwsManager.upload_document [hash].to_json
    hash = {
      'type': "add",
      'id': tender.ref_no,
      'fields': {
        'ref_no': tender.ref_no,
        'description': tender.description
      }
    }
    AwsManager.upload_document([hash].to_json) if Rails.env.production?
    NotifyViaSlack.call(content: "<@ganther> Tender Updated\r\nalerts.tengence.com.sg/admin/tender/#{tender.ref_no}")
  end
end