module BasicResources
  module Api
    module V1
      class ProducersController < ApplicationController
        before_action :authenticate
        before_action :load_producer, only: [:update, :destroy]
        before_action :load_group,
          only: [:create],
          if: -> { !!producer_params.fetch('group_id', nil) }

        # POST /api/v1/producers
        #
        # When creating a new producer we may pass a `group_id` param
        # to specify which group the producer will be:
        #  - associated with through `Membership`
        #
        # The generated `Membership` instance will be treated as a side effect
        # and returned with the POST response in the `Link` header.
        #
        # If no `group_id` is passed the producer will be associated
        # to the current user through `Membership`.
        #
        def create
          producer = Producer.new(producer_params.except(:group_id))
          producer_creator = ProducerCreator.new(
            producer: producer,
            creator: current_user,
            group: @current_group
          )

          if producer_creator.create! && producer.persisted?
            @side_effects << producer_creator.side_effects
            presenter = ProducerPresenter.new(producer, current_user)

            render json: ProducerSerializer.new(presenter)
          else
            render(
              status: :bad_request,
              json: { errors: producer.errors.messages }
            )
          end
        end

        # PUT /api/v1/producers/:id
        #
        def update
          if @producer.update_attributes(producer_params)
            presenter = ProducerPresenter.new(@producer, current_user)

            render json: ProducerSerializer.new(presenter)
          else
            render(
              status: :bad_request,
              json: { errors: @producer.errors.messages }
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
          @current_group = Group.find_by_id(params[:group_id])

          return head :not_found unless @current_group

          authorize @current_group, :update?
        end
      end
    end
  end
end
