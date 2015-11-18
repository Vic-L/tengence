class WatchedTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless params['query'].blank?
      @type = params['type']
      results = AwsManager.watched_tenders_search(keyword: params['query'], ref_nos_array: current_user.watched_tenders.pluck(:tender_id))
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      @current_tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
      @current_tenders_count = @current_tenders.size
      @past_tenders = PastTender.includes(:users).where(ref_no: results_ref_nos)
      @past_tenders_count = @past_tenders.size
    else
      current_tenders = CurrentTender.includes(:users).where(ref_no: current_user.watched_tenders.pluck(&:ref_no))
      @current_tenders = current_tenders.page(params[:page]).per(50)
      @current_tenders_count = current_tenders.size
      past_tenders = PastTender.includes(:users).where(ref_no: current_user.watched_tenders.pluck(&:ref_no))
      @past_tenders = past_tenders.page(params[:page]).per(50)
      @past_tenders_count = past_tenders.size
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
