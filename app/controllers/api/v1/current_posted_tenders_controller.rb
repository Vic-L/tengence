module Api
  module V1
    class CurrentPostedTendersController < ApiController
      before_action :api_deny_read_only_user

      def index
        @tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count = GetPostedTenders.call(params: params, table: "CurrentPostedTender", user: current_user)
        
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end