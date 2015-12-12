module Account
  module Api
    module V1
      class LoginController < ApplicationController

        def login
          login = login_params[:email] || login_params[:username]
          user = ::Account::User.where('username = :login OR email = :login', login: login).first

          if user && user.authenticate(login_params[:password])
            render status: :ok, json: UserSerializer.new(user)
          else
            head :unauthorized
          end
        end

        private

        def login_params
          params.permit(:username, :email, :password)
        end
      end
    end
  end
end
