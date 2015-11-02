class WatchedTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless params['query'].blank?
      results = AwsManager.watched_tenders_search(keyword: params['query'], ref_nos_array: current_user.watched_tenders.pluck(:tender_id))
      @results_count = results.hits.found
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      @tenders = Tender.where(ref_no: results_ref_nos)
    else
      @tenders = Tender.where(ref_no: current_user.watched_tenders.pluck(&:ref_no))
      @results_count = @tenders.size
    end
  end

  def create
    @watched_tender = WatchedTender.create(user_id: current_user.id, tender_id: params[:ref_no])
  end

  def destroy
    @tender = Tender.find(params[:id])
    WatchedTender.find_by(tender_id: params[:id]).destroy
  end
end
