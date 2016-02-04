class ViewedTendersController < ApplicationController
  def create
    if user_signed_in?
      ViewedTender.create(user_id: current_user.id, ref_no: params[:ref_no])
    end
    render nothing: true
  end
end