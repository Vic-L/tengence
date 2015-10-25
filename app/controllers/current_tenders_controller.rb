class CurrentTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    @tenders = CurrentTender.order(closing_datetime: :desc).page(params[:page])
  end
end
