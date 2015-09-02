module Account
  module Api
    module V1
      class SignupsController < ApplicationController

        def create
          signup = SignupService.new(signup_params[:email]).execute

          if signup
            render status: :ok, json: {}
          else
            render status: :bad_request,
              json: {
              model: signup.class.name,
              errors: signup.errors.full_messages
            }
          end
        end

        private

        def signup_params
          params.permit(:email)
        end
      end
    end
  end
end
