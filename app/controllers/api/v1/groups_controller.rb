module Api
  module V1
    class GroupsController < ApplicationController
      before_action :authenticate

      def index
        render json: Group.all
      end

      def show
        render json: Group.find(params[:id])
      end

      def create
        p groups_params
        group = Group.new(groups_params)
        group_creation = GroupCreation.new(group, current_user)
        if group_creation.create
          render json: group
        else
          render status: :bad_request,
                 json: {
                   model: group.class.name,
                   errors: group.errors.full_messages
                 }
        end
      end

      def update
        group = Group.find(params[:id])
        if group.update_attributes(groups_params)
          render json: group
        else
          render status: :bad_request,
                 json: {
                   model: group.class.name,
                   errors: group.errors.full_messages
                 }
        end
      end

      def destroy
        group = Group.find(params[:id])
        authorize group
        render json: group.destroy
      end

      private

      def groups_params
        params.require(:group).permit(:name, users_units_attributes: [:name, users_ids: [current_user.id.to_s]])
      end

    end
  end
end
