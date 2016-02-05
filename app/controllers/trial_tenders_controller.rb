class TrialTendersController < ApplicationController
  def create
    if user_signed_in?
      tender = TrialTender.create(user_id: current_user.id, tender_id: params[:ref_no])
      if tender.persisted?
        render json: current_user.trial_tender_ids.to_json
      else
        NotifyViaSlack.call(content: "<@vic-l> ERROR TrialTendersController#create\r\n#{current_user.email} trial tender #{params[:ref_no]}")
        render json: 'ignore'.to_json  
      end
    else
      render json: 'ignore'.to_json
    end
  end
end