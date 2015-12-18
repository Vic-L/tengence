class DestroyWatchedTenderWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true, :retry => false

  def perform user_id, tender_id
    WatchedTender.find_by(user_id: user_id,tender_id: tender_id).destroy
  end
end