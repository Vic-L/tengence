class WatchedTendersController < ApplicationController
  def create
    @watched_tender = WatchedTender.create(user_id: current_user.id, tender_id: params[:ref_no])
  end
end
