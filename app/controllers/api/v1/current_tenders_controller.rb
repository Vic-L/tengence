module Api
  module V1
    class CurrentTendersController < ApplicationController
      respond_to :json

      def index
        unless params['query'].blank?
          results = AwsManager.search(keyword: params['query'])
          results_ref_nos = results.hits.hit.map do |result|
            result.fields["ref_no"][0]
          end
          tenders = CurrentTender.where(ref_no: results_ref_nos)
          @tenders = tenders.page(params[:page]).per(50)
          @results_count = tenders.count
        else
          @results_count = CurrentTender.count
          @tenders = CurrentTender.page(params[:page]).per(50)
        end
        @current_page = @tenders.current_page
        @total_pages = @tenders.total_pages
        @limit_value = @tenders.limit_value
        @last_page = @tenders.last_page?
        @tenders = @tenders.to_a
        @watched_tender_ids = current_user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)
        respond_with @tenders, template: "/api/v1/tenders/index.json.jbuilder"
      end
    end
  end
end