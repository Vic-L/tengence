module Api
  module V1
    class KeywordsTendersController < ApplicationController
      respond_to :json

      def index
        @tenders, @current_page, @total_pages, @limit_value, @last_page, @results_count, @watched_tender_ids = GetKeywordsTenders.call(keywords: current_user.keywords, user: current_user, params: params)

        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end
