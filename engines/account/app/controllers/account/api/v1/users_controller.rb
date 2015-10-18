module Account
  module Api
    module V1
      class UsersController < ApplicationController

        before_action :authenticate, except: :create
        before_action :load_signup, only: :create
        before_action :load_user, only: [:show, :update, :destroy]

        # GET /api/v1/users
        #
        # TODO: review this
        #
        def index
          user = ::Group::User.find current_user.id
          users = ::Account::User.where(id: Group::Membership.where(group_id: user.group_ids).pluck(:user_id))

          render json: UsersSerializer.new(users)
        end

        # GET /api/v1/users/:id
        #
        def show
          authorize user

          render json: UserSerializer.new(user)
        end

        # POST /api/v1/users
        #
        # TODO: do not expose transaction errors directly,
        #       report it and respond with a custom error
        #
        def create
          user = ::Account::User.new(users_params)

          if user.valid?
            begin
              ::ActiveRecord::Base.transaction do
                user.save
                raise
                @signup.destroy

                render json: ::Account::UserSerializer.new(user)
              end
            rescue => e
              render status: :bad_request, json: { errors: [e.inspect] }
            end
          else
            render(
              status: :bad_request,
              json: {
                model: user.class.name,
                errors: user.errors.full_messages
              }
            )
          end
        end

        # PUT /api/v1/users/:id
        #
        def update
          authorize user

          if user.update_attributes(users_params)
            render json: UserSerializer.new(user)
          else
            render status: :bad_request,
              json: {
              model: user.class.name,
              errors: user.errors.full_messages
            }
          end
        end

        # DELETE /api/v1/users/:id
        #
        def destroy
          authorize user

          render json: Account::User.destroy(user.id)
        end

        private

        def users_params
          params.permit(:email, :username, :first_name, :last_name, :password, :password_confirmation)
        end

        def load_user
          @user = ::Account::User.find_by_id(params[:id])
          render status: :not_found, nothing: true unless @user
        end

        def load_signup
          signup_token = request.headers['HTTP_X_KATUMA_SIGNUP_TOKEN']
          @signup = ::Account::Signup.where(token: signup_token, email: users_params[:email]).first
          unless @signup
            render status: :bad_request, json: { errors: ['Please check your Signup information'] }
          end
        end
      end
    end
  end
end
