module Api
  module V1
    class SessionsController < ApplicationController

      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          session[:current_user_id] = user.id
          render nothing: true, status: 201
        else
          render nothing: true, status: 401
        end
      end

      # Removes the user id from the session
      def destroy
        @_current_user = session[:current_user_id] = nil

        render nothing: true, status: 200
      end
    end
  end
end
