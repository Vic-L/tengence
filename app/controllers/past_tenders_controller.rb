class PastTendersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_write_only_access
  before_action :deny_unconfirmed_users
  before_action :check_user_keywords

  def index
    # unless params['query'].blank?
    #   results_ref_nos = AwsManager.search(keyword: params['query'])
    #   tenders = PastTender.includes(:users).where(ref_no: results_ref_nos)
    #   @tenders = tenders.page(params[:page]).per(50)
    #   @results_count = @tenders.count
    # else
    #   params[:page] = 0 if params['query'] == ''
    #   @results_count = PastTender.count
    #   @tenders = PastTender.includes(:users).page(params[:page]).per(50)
    # end
  end
end
