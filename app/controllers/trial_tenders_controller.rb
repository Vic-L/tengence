class TrialTendersController < ApplicationController
  def create
    if user_signed_in?
      tender = TrialTender.create(user_id: current_user.id, tender_id: params[:ref_no])
      if tender.persisted?
        
      else
        NotifyViaSlack.call(content: "<@vic-l> ERROR TrialTendersController#create\r\n#{current_user.email} trial tender #{params[:ref_no]}\r\n#{tender.errors.full_messages.to_sentence}")
      end
      render json: current_user.trial_tender_ids.to_json
    else
      render json: 'ignore'.to_json
    end
  end
end