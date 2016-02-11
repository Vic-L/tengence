class CurrentTendersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_write_only_access
  before_action :deny_unconfirmed_users
  before_action :check_user_keywords

  def index
    @current_tenders_count = CurrentTender.count
    # unless params['query'].blank?
    #   results_ref_nos = AwsManager.search(keyword: params['query'])
    #   tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
    #   @tenders = tenders.page(params[:page]).per(50)
    #   @results_count = tenders.count
    # else
    #   @results_count = CurrentTender.count
    #   @tenders = CurrentTender.includes(:users).page(params[:page]).per(50)
    # end
  end
end
