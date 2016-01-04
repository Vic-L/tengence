module Api
  module V1
    class WatchedTendersController < ApplicationController
      respond_to :json

      def index
        @tenders, @current_page, @total_pages, @limit_value, @last_page, @watched_tender_ids, @results_count = GetTenders.call(params: params, table: "CurrentTender", user: current_user)
        
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end

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