class KeywordsTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.keywords.blank?
      flash.now[:alert] = "You did not input any keywords."
    else
      results_ref_nos = []
      current_user.keywords.split(",").each do |keyword|
        # get tenders for each keyword belonging to a user
        results = AwsManager.search(keyword: keyword)
        results_ref_nos << results.hits.hit.map do |result|
          result.fields["ref_no"][0]
        end
      end
      results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
      @tenders = CurrentTender.where(ref_no: results_ref_nos).page(params[:page]).per(50)
      @results_count = @tenders.size
    end
  end
end
