module Api
  module V1
    class WatchedTendersController < ApplicationController
      respond_to :json

      def create
        @watched_tender = WatchedTender.create(user_id: current_user.id, tender_id: params[:id])
        render json: params[:id].to_json
      end

      def destroy
        DestroyWatchedTenderWorker.perform_async(current_user.id,params[:id])
        render json: params[:id].to_json
      end
    end
  end
end