module Group
  module Api
    module V1
      class GroupsController < ApplicationController

        before_action :authenticate
        before_action :find_and_authorize_group, only: [:show, :update, :destroy]

        def index
          render json: GroupsSerializer.new(current_user.groups)
        end

        def show
          render json: GroupSerializer.new(@group)
        end

        def create
          group = ::Group::Group.new(group_params)
          group_creation = GroupCreation.new(group, current_user)
          if group_creation.create
            render json: GroupSerializer.new(group)
          else
            render(
              status: :bad_request,
              json: {
                model: group.class.name,
                errors: group.errors.full_messages
              }
            )
          end
        end

        def update
          if @group.update_attributes(group_params)
            render json: GroupSerializer.new(@group)
          else
            render(
              status: :bad_request,
              json: {
                model: @group.class.name,
                errors: @group.errors.full_messages
              }
            )
          end
        end

        def destroy
          render json: @group.destroy
        end

        private

        def group_params
          params.permit(:name)
        end

        def find_and_authorize_group
          @group = ::Group::Group.find(params[:id])

          authorize @group
        end
      end
    end
  end
end
