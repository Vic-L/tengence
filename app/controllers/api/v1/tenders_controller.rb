module Api
  module V1
    class TendersController < ApplicationController
      respond_to :json

      def show
        @tender = Tender.find_by(ref_no: params[:id])
      end
    end
  end
end