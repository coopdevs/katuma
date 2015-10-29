module Group
  module Api
    module V1
      class GroupsController < ApplicationController

        before_action :authenticate
        before_action :find_and_authorize_group, only: [:show, :update, :destroy]
        before_action :initialize_side_effects, only: [:create]
        after_action :add_side_effects_links, only: [:create]

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
              json: {
                model: group.class.name,
                errors: group.errors
              }
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

          authorize @group
        end

        def initialize_side_effects
          @side_effects = []
        end

        # TODO: Extract this to lib or gem
        #
        def add_side_effects_links
          return unless @side_effects.any

          links = @side_effects.flatten.map do |side_effect|
            "<#{api_link(side_effect)}>; rel=\"created\" type=\"#{model_type(side_effect)}\""
          end.join(', ')

          response.headers['Link'] = links
        end

        def api_link(side_effect)
          "#{web_app_url}/api/v1/#{model_type(side_effect).downcase.pluralize}/#{side_effect.id}"
        end

        def model_type(side_effect)
          side_effect.class.name
        end
      end
    end
  end
end
