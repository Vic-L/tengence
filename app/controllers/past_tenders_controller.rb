class PastTendersController < ApplicationController
  before_action :authenticate_user!

  def index
    @tenders = PastTender.order(closing_datetime: :desc).page(params[:page])
  end
end
