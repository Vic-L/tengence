class RemoveSingleTenderFromCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform ref_no, description
    hash = {
      'type': "delete",
      'id': ref_no
    }
    puts hash.to_s
    AwsManager.upload_document [hash].to_json
    NotifyViaSlack.call(content: "<@ganther> Tender #{ref_no} removed from CloudSearch")
  end
end