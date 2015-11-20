class AddSingleTenderToCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform ref_no
    tender = Tender.find(ref_no)
    # hash = {
    #   'type': "add",
    #   'id': tender.ref_no,
    #   'fields': {
    #     'ref_no': tender.ref_no,
    #     'description': tender.description
    #   }
    # }
    # AwsManager.upload_document [hash].to_json
    NotifyViaSlack.call(content: "<@ganther> New Tender Posted\r\nalerts.tengence.com.sg/admin/tenders/#{tender.ref_no}")
  end
end