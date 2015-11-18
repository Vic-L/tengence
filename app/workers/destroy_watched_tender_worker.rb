class DestroyWatchedTenderWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform tender_id
    WatchedTender.find_by(tender_id: tender_id).destroy
  end
end