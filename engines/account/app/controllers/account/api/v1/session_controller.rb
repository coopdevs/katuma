module Account
  module Api
    module V1
      class SessionController < ApplicationController

        def login
          user = ::Account::User.find_by_email(login_params[:email])

          if user && user.authenticate(login_params[:password])
            session[:current_user_id] = user.id
            render status: :ok, json: UserSerializer.new(current_user)
          else
            render status: :unauthorized, json: {}
          end
        end

        # Logs out the user
        #
        def logout
          @_current_user = session[:current_user_id] = nil

          render status: :ok, json: {}
        end        

        private

        def login_params
          params.permit(:email, :password)
        end
      end
    end
  end
end
