module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      before_action :deny_non_logged_in_user

      def deny_non_logged_in_user
        if !user_signed_in?
          render json: {error: "Access Denied"}, status: 403
        end
      end      
    end
  end
end