class RemoveSingleTenderFromCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform ref_no
    tender = Tender.find(ref_no)
    hash = {
      'type': "delete",
      'id': tender.ref_no
    }
    AwsManager.upload_document [hash].to_json
    NotifyViaSlack.call(content: "<@ganther> Tender #{ref_no} removed from CloudSearch")
  end
end