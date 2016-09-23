module Group
  module Api
    module V1
      class GroupsController < ApplicationController

        before_action :authenticate
        before_action :find_and_authorize_group, only: [:show, :update, :destroy]

        # GET api/v1/groups
        #
        def index
          render json: GroupsSerializer.new(current_user.groups)
        end

        # GET api/v1/groups/:id
        #
        def show
          render json: GroupSerializer.new(@group)
        end

        # POST api/v1/groups
        #
        def create
          group = ::Group::Group.new(group_params)
          group_creator = GroupCreator.new(group, current_user)
          if group_creator.create
            @side_effects << group_creator.side_effects
            render json: GroupSerializer.new(group)
          else
            render(
              status: :bad_request,
              json: group.errors.to_json
            )
          end
        end

        # PUT api/v1/groups/:id
        #
        def update
          if @group.update_attributes(group_params)
            render json: GroupSerializer.new(@group)
          else
            render(
              status: :bad_request,
              json: {
                model: @group.class.name,
                errors: @group.errors
              }
            )
          end
        end

        # DELETE api/v1/groups/:id
        #
        def destroy
          render json: @group.destroy
        end

        private

        def group_params
          params.permit(:name)
        end

        def find_and_authorize_group
          @group = ::Group::Group.find_by_id(params[:id])

          return head :not_found unless @group

          authorize @group
        end
      end
    end
  end
end
