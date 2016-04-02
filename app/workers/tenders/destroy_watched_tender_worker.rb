class DestroyWatchedTenderWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => 5, :retry => false

  def perform user_id, tender_id
    tender = Tender.find(tender_id)
    user  = User.find(user_id)
    NotifyViaSlack.delay.call(content: "Tender unwatched by #{user.email}\r\n#{tender.description}")
    WatchedTender.find_by(user_id: user_id,tender_id: tender_id).destroy
  end
end