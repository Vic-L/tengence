module Api
  module V1
    class PastTendersController < ApiController
      def index
        @tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count = GetTenders.call(params: params, table: "PastTender", user: current_user)

        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end