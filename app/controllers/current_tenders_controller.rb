class CurrentTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless params['query'].blank?
      results = AwsManager.search(keyword: params['query'])
      @results_count = results.hits.found
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      @tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos).page(params[:page]).per(50)
    else
      @results_count = CurrentTender.count
      @tenders = CurrentTender.includes(:users).page(params[:page]).per(50)
    end
  end
end
