module Api
  module V1
    class PastTendersController < ApplicationController
      respond_to :json

      def index
        unless params['query'].blank?
          results = AwsManager.search(keyword: params['query'])
          results_ref_nos = results.hits.hit.map do |result|
            result.fields["ref_no"][0]
          end
          tenders = PastTender.where(ref_no: results_ref_nos)
          @tenders = tenders.page(params[:page]).per(50)
          @results_count = @tenders.count
        else
          params[:page] = 0 if params['query'] == ''
          @results_count = PastTender.count
          @tenders = PastTender.page(params[:page]).per(50)
        end
        @current_page = @tenders.current_page
        @total_pages = @tenders.total_pages
        @limit_value = @tenders.limit_value
        @last_page = @tenders.last_page?
        @tenders = @tenders.to_a
        @watched_tender_ids = current_user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)
      end
    end
  end
end