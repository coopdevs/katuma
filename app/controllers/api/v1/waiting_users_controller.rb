module Api
  module V1
    class WaitingUsersController < ApplicationController

      before_action do
        @group = Group.find(params[:group_id])
      end
      before_action except: :index do
        @user = User.find(waiting_users_params[:user_id])
      end

      def index
        render json: User.with_role :waiting_user, @group
      end

      def create
        if @user.add_role :waiting:user, @group
          render json: User.with_role :waiting_user, @group
        end
      end

      def destroy
        if @user.remove_role :waiting_user, @group
          render json: User.with_role :waiting_user, @group
        end
      end

      private

      def waiting_users_params
        params.require(:waiting_users).permit(:user_id)
      end
    end
  end
end
