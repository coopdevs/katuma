module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.where("email = ?", params[:email]).first
        if user && user.authenticate(params[:password])
          render json: user.session_api_key, status: 201
        else
          render json: {}, status: 401
        end
      end
    end
  end
end
