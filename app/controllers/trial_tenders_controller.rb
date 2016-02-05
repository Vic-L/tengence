class TrialTendersController < ApplicationController
  def create
    if user_signed_in?
      TrialTender.create(user_id: current_user.id, tender_id: params[:ref_no])
    end
    render json: 'success'.to_json
  end
end