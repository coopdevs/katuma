module Api
  module V1
    class GroupsController < ApplicationController
      before_action :find_and_authorize_group,
        only: [:show, :update, :destroy]

      def index
        groups = Group.with_role(:admin, current_user)
        render json: GroupsSerializer.new(groups)
      end

      def show
        render json: GroupSerializer.new(@group)
      end

      def create
        group = Group.new(create_params)
        group_creation = GroupCreation.new(group, current_user)
        if group_creation.create
          render json: GroupSerializer.new(group)
        else
          render status: :bad_request,
                 json: {
                   model: group.class.name,
                   errors: group.errors.full_messages
                 }
        end
      end

      def update
        if @group.update_attributes(update_params)
          render json: GroupSerializer.new(@group)
        else
          render status: :bad_request,
                 json: {
                   model: @group.class.name,
                   errors: @group.errors.full_messages
                 }
        end
      end

      def destroy
        render json: @group.destroy
      end

      private

      def create_params
        params.require(:group).permit(:name, users_units_attributes: [:name])
      end

      def update_params
        params.require(:group).permit(:name)
      end

      def find_and_authorize_group
        @group = Group.find(params[:id])
        authorize @group
      end

    end
  end
end
