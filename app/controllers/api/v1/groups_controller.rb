module Api
  module V1
    class GroupsController < ApplicationController

      def index
        render json: Group.all
      end

      def show
        render json: Group.find(params[:id])
      end

      def create
        group = Group.new(groups_params)
        if group.save
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
        render json: Group.destroy(params[:id])
      end

      private

      def groups_params
        params.require(:group).permit(:name)
      end

    end
  end
end
