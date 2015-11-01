class KeywordsTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.keywords.blank?
      flash.now[:alert] = "You did not input any keywords."
    else
      results_ref_nos = []
      current_user.keywords.split(",").each do |keyword|
        # get tenders for each keyword belonging to a user
        results = AwsManager.watched_tenders_search(keyword, CurrentTender.pluck(:ref_no))
        results_ref_nos << results.hits.hit.map do |result|
          result.fields["ref_no"][0]
        end
      end
      results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
      @results_count = results_ref_nos.size
      @tenders = CurrentTender.where(ref_no: results_ref_nos).page(params[:page]).per(50)
    end
  end
end
