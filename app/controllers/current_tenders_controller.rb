class CurrentTendersController < ApplicationController
  before_action :deny_write_only_access

  def index
    unless params['query'].blank?
      results = AwsManager.search(keyword: params['query'])
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
      @tenders = tenders.page(params[:page]).per(50)
      @results_count = tenders.count
    else
      @results_count = CurrentTender.count
      @tenders = CurrentTender.includes(:users).page(params[:page]).per(50)
    end
  end
end
