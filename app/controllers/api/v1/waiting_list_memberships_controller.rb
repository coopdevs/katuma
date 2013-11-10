module Api
  module V1
    class WaitingListMembershipsController < ApplicationController

      before_action do
        @group = Group.find(params[:group_id])
      end

      def index
        render json: @group.waiters
      end

      def create
        render json: @group.waiters << User.find(waiting_list_memberships_params[:user_ids])
      end

      def destroy
        render json: @group.waiters.delete(User.find(waiting_list_memberships_params[:user_ids]))
      end

      private

      def waiting_list_memberships_params
        params.require(:waiting_list).permit(user_ids: [])
      end

    end
  end
end
