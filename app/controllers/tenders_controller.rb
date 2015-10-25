class TendersController < ApplicationController
  def index
    @tenders = Tender.order(:name).page params[:page]
  end
end
