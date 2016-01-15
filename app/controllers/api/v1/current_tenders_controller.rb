module Api
  module V1
    class CurrentTendersController < ApplicationController
      respond_to :json

      def index
        if current_user
          @tenders, @current_page, @total_pages, @limit_value, @last_page, @watched_tender_ids, @results_count = GetTenders.call(params: params, table: "CurrentTender", user: current_user)
        else
          @tenders, @current_page, @total_pages, @limit_value, @last_page, @watched_tender_ids, @results_count = GetDemoTenders.call(params: params, table: "CurrentTender")
        end
        
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end