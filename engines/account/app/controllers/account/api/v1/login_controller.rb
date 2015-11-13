module Account
  module Api
    module V1
      class LoginController < ApplicationController

        def login
          user = ::Account::User.find_by_email(login_params[:email])

          if user && user.authenticate(login_params[:password])
            render status: :ok, json: UserSerializer.new(user)
          else
            head :unauthorized
          end
        end

        private

        def login_params
          params.permit(:email, :password)
        end
      end
    end
  end
end
