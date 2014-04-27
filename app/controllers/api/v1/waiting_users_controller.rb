module Api
  module V1
    class WaitingUsersController < ApplicationController
      before_action :authenticate
      before_action :find_group_and_authorize,
        only: :index
      before_action :find_group_and_user_and_authorize,
        except: :index

      def index
        render json: @waiting_user.list
      end

      def create
        if @waiting_user.add!
          render nothing: true, status: :success
        end
      end

      def destroy
        if @waiting_user.remove!
          render nothing: true, status: :success
        end
      end

      private

      def waiting_users_params
        params.require(:waiting_users).permit(:user_id)
      end

      def find_group_and_authorize
        @group = Group.find(params[:group_id])

        if @group
          @waiting_user = WaitingUser.new(@group)
          authorize @waiting_user
        end
      end

      def find_group_and_user_and_authorize
        @group = Group.find(params[:group_id])
        @user = User.find(waiting_users_params[:user_id])

        if @group && @user
          @waiting_user = WaitingUser.new(@group, @user)
          authorize @waiting_user
        end
      end
    end
  end
end
