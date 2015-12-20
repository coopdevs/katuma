module Producers
  module Api
    module V1
      class ProducersController < ApplicationController
        before_action :load_producer, only: [:show, :update, :destroy]
        before_action :load_current_group, only: [:create]

        # GET /api/v1/producers
        #
        def index
          # TODO: find a better way to deal with dependencies
          #       we're making the User query twice here :scream:
          user = ::Group::User.find(current_user.id)

          # TODO: move to a finder object
          # TODO: although `group_id` is not a Provider thing maybe we can add it as a filter here
          producer_ids = ::Suppliers::Supplier.where(group_id: user.group_ids).pluck(:producer_id)
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
        # When creating a new producer we may pass a `X-KATUMA-GROUP-ID-FOR-PROVIDER`
        # header in the POST request to specify which group the provider
        # will be attached to as a supplier.
        #
        # The generated `Supplier` instance will be treated as a side effect
        # and returned in the POST response in the `Link` header.
        #
        def create
          producer = Producer.new(producer_params)

          producer_creator = ProducerCreator.new(producer, current_user, @current_group)
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
            render :show
          else
            render :show, status: :bad_request
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
          params.permit(:name, :email, :address)
        end

        def load_producer
          @producer = Producer.find_by_id(params[:id])
        end

        def load_current_group
          @current_group = ::Suppliers::Group.find_by_id(request.headers['HTTP_X_KATUMA_GROUP_ID_FOR_PROVIDER'])

          return head :not_found unless @current_group

          Pundit.policy!(current_user, @current_group).add_supplier?
        end
      end
    end
  end
end
