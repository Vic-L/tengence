class TrialTendersController < ApplicationController
  def create
    if user_signed_in?
      if current_user.trial_tenders_count < 3
        tender = TrialTender.create(user_id: current_user.id, tender_id: params[:ref_no])
        if tender.persisted?
          NotifyViaSlack.delay.call(content: "TrialTender UNLOCKED by #{current_user.email}: \r\n#{Tender.find(tender.tender_id).description}")
          render json: {statusCode: 'success',trial_tender_ids: current_user.trial_tender_ids}.to_json
        else
          NotifyViaSlack.delay.call(content: "<@vic-l> ERROR TrialTendersController#create\r\n#{current_user.email} trial tender #{params[:ref_no]}\r\n#{tender.errors.full_messages.to_sentence}")
          render json: {statusCode: 'success',trial_tender_ids: current_user.trial_tender_ids}.to_json
        end
      else
        render json: {statusCode: 'maxed_for_the_day',trial_tender_ids: current_user.trial_tender_ids}.to_json
      end
    else
      render json: 'User is not logged in', status: 400
    end
  end
end