module Account
  module Api
    module V1
      class LoginController < ApplicationController

        def login
          user = ::Account::User.find_by_login(login_params[:login])

          if user && user.authenticate(login_params[:password])
            render status: :ok, json: UserSerializer.new(user)
          else
            head :unauthorized
          end
        end

        private

        def login_params
          params.permit(:login, :password)
        end
      end
    end
  end
end
