module Account
  module Api
    module V1
      class UsersController < ApplicationController

        before_action :authenticate, except: :create

        def index
          users = User.where(id: Membership.where(group_id: current_user.group_ids).pluck(:user_id))

          render json: UsersSerializer.new(users)
        end

        def show
          user = User.find(params[:id])
          authorize user

          render json: UserSerializer.new(user)
        end

        def create
          user = User.new(users_params)
          if user.save
            session[:current_user_id] = user.id
            render json: UserSerializer.new(user)
          else
            render status: :bad_request,
              json: {
              model: user.class.name,
              errors: user.errors.full_messages
            }
          end
        end

        def update
          user = User.find(params[:id])
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

        def destroy
          user = User.find(params[:id])
          authorize user

          render json: User.destroy(user.id)
        end

        def account
          render json: UserSerializer.new(current_user)
        end

        private

        def users_params
          params.permit(:name, :email, :password, :password_confirmation)
        end
      end
    end
  end
end
