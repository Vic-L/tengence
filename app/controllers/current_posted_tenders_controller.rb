class CurrentPostedTendersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_read_only_access

  def index
    @results_count = CurrentPostedTender.count
    @tenders = CurrentPostedTender.includes(:users).page(params[:page]).per(50)
  end
end
