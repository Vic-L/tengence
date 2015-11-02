class TendersController < ApplicationController
  before_action :store_location
  before_action :authenticate_user!

  def show
    @tender = Tender.find_by(ref_no: params[:id])
  end

  private
    def store_location
      unless user_signed_in?
        store_location_for(:users, request.original_url)
      end
    end
end