module Account
  module Api
    module V1
      class UsersController < ApplicationController
        before_action :authenticate, except: :create
        before_action :load_user, only: [:show, :update, :destroy]

        # GET /api/v1/users
        #
        def index
          user = ::BasicResources::User.find current_user.id
          user_ids = ::BasicResources::Membership
            .where(basic_resource_group_id: user.group_ids)
            .pluck(:user_id)
          users = ::Account::User.where(id: user_ids)

          render json: UsersSerializer.new(users)
        end

        # GET /api/v1/users/:id
        #
        def show
          authorize user

          render json: UserSerializer.new(user)
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
          params
            .permit(:email, :username, :first_name, :last_name, :password, :password_confirmation)
        end

        def load_user
          @user = ::Account::User.find_by_id(params[:id])

          head :not_found unless @user
        end
      end
    end
  end
end
