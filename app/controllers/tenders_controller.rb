class TendersController < ApplicationController
  before_action :authenticate_user!

  def show
    @tender = Tender.find_by(ref_no: params[:id])
  end
end