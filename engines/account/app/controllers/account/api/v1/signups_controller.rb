module Account
  module Api
    module V1
      class SignupsController < ApplicationController
        before_action :check_email_availability, only: [:create]
        before_action :load_signup, only: [:show, :complete]

        # POST /api/v1/signups
        #
        def create
          signup = SignupService.new().create!(signup_create_params[:email])

          if signup.valid? && signup.persisted?
            head :created
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
          render status: :ok, json: { email: @signup.email }
        end

        # POST /api/v1/signups/complete/:token
        #
        def complete
          user = SignupService.new().complete!(@signup, signup_complete_params)

          if user.valid? && user.persisted?
            render json: UserSerializer.new(user)
          else
            render(
              status: :bad_request,
              json: user.errors.to_json
            )
          end
        end

        private

        def signup_create_params
          params.permit(:email)
        end

        def signup_show_params
          params.permit(:token)
        end

        def signup_complete_params
          params
            .permit(:token, :username, :first_name, :last_name, :password, :password_confirmation)
        end

        def check_email_availability
          user = ::Account::User.find_by_email(signup_create_params[:email])

          return unless user

          render(
            status: :bad_request,
            json: {
              errors: ['A user already exists with the given email']
            }
          )
        end

        def load_signup
          @signup = ::Account::Signup.find_by_token(signup_show_params[:token])

          return if @signup

          head :not_found
        end
      end
    end
  end
end
