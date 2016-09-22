module Producers
  module Api
    module V1
      class ProducersController < ApplicationController
        before_action :authenticate
        before_action :load_producer, only: [:show, :update, :destroy]
        before_action :load_group,
          only: [:create],
          if: -> { !!producer_params.fetch('group_id', nil) }

        # GET /api/v1/producers
        #
        def index
          group_ids = ::Group::Membership.where(user_id: current_user.id).pluck(:group_id)
          producer_ids = Membership.where(
            'producers_memberships.user_id = ? OR producers_memberships.group_id IN (?)',
            current_user.id,
            group_ids
          ).pluck(:producer_id)
          producers = Producer.where(id: producer_ids)

          render json: ProducersSerializer.new(producers)
        end

        # GET /api/v1/producers/:id
        #
        def show
          render json: ProducerSerializer.new(@producer)
        end

        # POST /api/v1/producers
        #
        # When creating a new producer we may pass a `group_id` param
        # to specify which group the producer will be:
        #  - associated with through `::Producers::Membership`
        #  - associated with as a supplier through `::Suppliers::Supplier`
        #
        # The generated `Supplier` instance will be treated as a side effect
        # and returned in the POST response in the `Link` header.
        #
        # If no `group_id` is passed the producer will only be associated
        # to the current user through `::Producers::Membership`.
        #
        def create
          producer = Producer.new(producer_params.except(:group_id))
          producer_creator = ProducerCreator.new(
            producer: producer,
            creator: current_user,
            group: @current_group
          )

          if producer_creator.create
            @side_effects << producer_creator.side_effects
            render json: ProducerSerializer.new(producer)
          else
            render(
              status: :bad_request,
              json: producer.errors.to_json
            )
          end
        end

        # PUT /api/v1/producers/:id
        #
        def update
          if @producer.update_attributes(producer_params)
            render json: ProducerSerializer.new(@producer)
          else
            render(
              status: :bad_request,
              json: producer.errors.to_json
            )
          end
        end

        # DELETE /api/v1/producers/:id
        #
        def destroy
          if @producer.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def producer_params
          params.permit(:name, :email, :address, :group_id)
        end

        def load_producer
          @producer = Producer.find_by_id(params[:id])

          return head :not_found unless @producer

          authorize @producer
        end

        def load_group
          @current_group = ::Producers::Group.find_by_id(params[:group_id])

          return head :not_found unless @current_group

          authorize @current_group
        end
      end
    end
  end
end
