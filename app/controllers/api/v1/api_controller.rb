module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      before_action :api_deny_non_logged_in_user

      protected
        def api_deny_non_logged_in_user
          if !user_signed_in?
            render json: {error: "Access Denied"}, status: 403
          end
        end

        def api_deny_read_only_user
          if user_signed_in? && current_user.read_only?
            render json: {error: "Access Denied"}, status: 403
          end
        end

        def api_deny_write_only_user
          if user_signed_in? && current_user.write_only?
            render json: {error: "Access Denied"}, status: 403
          end
        end
    end
  end
end