module Account
  module Api
    module V1
      class UsersController < ApplicationController

        before_action :authenticate, except: :create

        def index
          user = Group::User.find current_user.id
          users = Account::User.where(id: Group::Membership.where(group_id: user.group_ids).pluck(:user_id))

          render json: UsersSerializer.new(users)
        end

        def show
          user = Account::User.find(params[:id])
          authorize user

          render json: UserSerializer.new(user)
        end

        def create
          user = Account::User.new(users_params)
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
          user = Account::User.find(params[:id])
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
          user = Account::User.find(params[:id])
          authorize user

          render json: Account::User.destroy(user.id)
        end

        def account
          render json: UserSerializer.new(current_user)
        end

        private

        def users_params
          params.permit(:name, :email, :username, :first_name, :last_name, :password, :password_confirmation)
        end
      end
    end
  end
end
