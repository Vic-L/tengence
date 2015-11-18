class WatchedTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless params['query'].blank?
      @type = params['type']
      results = AwsManager.search(keyword: params['query'])
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      
      results_ref_nos = results_ref_nos & current_user.watched_tenders.pluck(:tender_id)
      
      current_tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
      @current_tenders = current_tenders.page(params[:page]).per(50)
      @current_tenders_count = current_tenders.size
      
      past_tenders = PastTender.includes(:users).where(ref_no: results_ref_nos)
      @past_tenders = past_tenders.page(params[:page]).per(50)
      @past_tenders_count = past_tenders.size
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
    @tender_ref_no = params[:ref_no]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tender_ref_no = params[:id]
    DestroyWatchedTenderWorker.perform_async(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
