class ViewedTendersController < ApplicationController
  def create
    ViewedTender.create(user_id: current_user.id, ref_no: params[:ref_no])
    render nothing: true
  end
end