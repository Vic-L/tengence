class WatchedTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params['query']
      results = AwsManager.watched_tenders_search(params['query'],current_user.watched_tenders.pluck(:tender_id))
      @results_count = results.hits.found
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      @current_watched_tenders = CurrentTender.where(ref_no: results_ref_nos)
      @past_watched_tenders = PastTender.where(ref_no: results_ref_nos)
    else
      @current_watched_tenders = CurrentTender.where(ref_no: current_user.watched_tenders.pluck(&:ref_no))
      @past_watched_tenders = PastTender.where(ref_no: current_user.watched_tenders.pluck(&:ref_no))
    end
  end

  def create
    @watched_tender = WatchedTender.create(user_id: current_user.id, tender_id: params[:ref_no])
  end
end
