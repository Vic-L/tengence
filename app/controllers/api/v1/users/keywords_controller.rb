module Api
  module V1
    class Users::KeywordsController < ApplicationController
      respond_to :json

      def update
        current_user.keywords = params[:keywords]
        if current_user.valid?
          if current_user.save
            render :json => { :success => true }
          else
            render json: {errors: current_user.errors.full_messages.to_sentence}, status: 500
          end
        else
          render json: {errors: current_user.errors.full_messages.to_sentence}, status: 500
        end

      end
    end
  end
end