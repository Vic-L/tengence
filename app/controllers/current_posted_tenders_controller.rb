class CurrentPostedTendersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_read_only_access
  before_action :deny_unconfirmed_users

  def index
    tenders = current_user.current_posted_tenders
    @results_count = tenders.count
    @tenders = tenders.includes(:postee).page(params[:page]).per(50)
  end
end
