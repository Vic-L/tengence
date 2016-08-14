module Api
  module V1
    class CurrentTendersController < ApiController
      before_action :api_deny_write_only_user

      def index
        @tenders, @current_page, @total_pagesCHAT_MESSAGE_UNAUTHORIZED, @last_page, @watched_tender_ids, @results_count = GetTenders.call(params: params, table: "CurrentTender", user: current_user)
        
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end