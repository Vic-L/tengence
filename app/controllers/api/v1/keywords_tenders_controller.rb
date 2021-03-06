module Api
  module V1
    class KeywordsTendersController < ApiController
      before_action :api_deny_write_only_user
      
      def index
        @tenders, @current_page, @total_pages, @last_page, @results_count, @watched_tender_ids = GetKeywordsTenders.call(keywords: current_user.keywords, user: current_user, params: params)

         render template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end
