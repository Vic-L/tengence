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
          tenders = PastTender.includes(:users).where(ref_no: results_ref_nos)
          @tenders = tenders.page(params[:page]).per(50)
          @results_count = @tenders.count
        else
          params[:page] = 0 if params['query'] == ''
          @results_count = PastTender.count
          @tenders = PastTender.includes(:users).page(params[:page]).per(50)
        end
        respond_with @tenders
      end
    end
  end
end