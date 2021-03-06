module Api
  module V1
    class WatchedTendersController < ApiController
      before_action :api_deny_write_only_user
      
      def index
        @tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count = GetTenders.call(
          params: params, 
          table: params[:table] || 'CurrentTender', 
          user: current_user,
          source: 'watched_tenders')
        
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end

      def create
        @watched_tender = WatchedTender.create(user_id: current_user.id, tender_id: params[:id])
        NotifyViaSlack.delay.call(content: "Tender (#{params[:id]}) watched by #{current_user.email}\r\n#{tender_url(id: params[:id])}")
        render json: params[:id].to_json
      end

      def destroy
        tender_id = URI.unescape(params[:id])
        DestroyWatchedTenderWorker.perform_async(current_user.id,tender_id)
        render json: tender_id.to_json
      end

      def mass_destroy
        current_user.watched_tenders.where(tender_id: params[:ids]).destroy_all
        render json: params[:ids].to_json
      end
    end
  end
end