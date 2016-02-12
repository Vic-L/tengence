class AddSingleTenderToCloudsearchWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => false

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
    NotifyViaSlack.call(content: "<@ganther> New Tender Posted\r\nwww.tengence.com.sg/admin/tender/#{ref_no}") if Rails.env.production?

    Tengence::Application.load_tasks
    Rake::Task['maintenance:refresh_cache'].reenable
    Rake::Task['maintenance:refresh_cache'].invoke
  end
end