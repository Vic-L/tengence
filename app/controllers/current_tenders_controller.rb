class CurrentTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params['query']
      results = AwsManager.search(params['query'])
      @results_count = results.hits.found
      results_ref_nos = results.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
      @tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos).page(params[:page]).per(50)
    else
      @tenders = CurrentTender.includes(:users).page(params[:page]).per(50)
    end
  end
end
