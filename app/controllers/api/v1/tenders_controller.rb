module Api
  module V1
    class TendersController < ApiController
      def show
        @tender = Tender.find_by(ref_no: params[:id])
      end
    end
  end
end