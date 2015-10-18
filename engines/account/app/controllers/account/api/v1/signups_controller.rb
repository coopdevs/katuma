module Account
  module Api
    module V1
      class SignupsController < ApplicationController

        # POST /api/v1/signups
        #
        def create
          signup = SignupService.new().create!(signup_params[:email])

          if signup.valid? && signup.persisted?
            render status: :ok, nothing: true
          else
            render(
              status: :bad_request,
              json: { errors: signup.errors.full_messages }
            )
          end
        end

        # GET /signups/:token
        #
        # TODO: better serialized response
        #
        def show
          signup = ::Account::Signup.find_by_token(signup_show_params[:token])

          if signup
            render status: :ok, json: { email: signup.email }
          else
            render status: :not_found, nothing: true
          end
        end

        private

        def signup_params
          params.permit(:email)
        end

        def signup_show_params
          params.permit(:token)
        end
      end
    end
  end
end
