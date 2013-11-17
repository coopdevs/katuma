module Api
  module V1
    class WaitingUsersController < ApplicationController

      before_action except: :update do
        @group = Group.find(params[:group_id])
      end

      def index
        render json: @group.waiting_users
      end

      def create
        if @group.waiting_users << User.find(waiting_users_params[:user_id])
          render json: @group.waiting_users
        end
      end

      def destroy
        if @group.waiting_users.delete User.find(waiting_users_params[:user_id])
          render json: @group.waiting_users
        end
      end

      private

      def waiting_users_params
        params.require(:waiting_users).permit(:user_id)
      end
    end
  end
end
