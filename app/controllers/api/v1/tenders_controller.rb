module Api
  module V1
    class TendersController < ApiController
      skip_before_action :api_deny_non_logged_in_user

      def show
        @tender = Tender.find_by(ref_no: params[:id])
      end
    end
  end
end