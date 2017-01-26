module Suppliers
  module Api
    module V1
      class OrdersFrequenciesController < ApplicationController
        before_action :authenticate
        before_action :load_orders_frequency, only: [:show, :update]
        before_action :load_group, only: [:index, :create]

        # GET /api/v1/orders_frequencies?group_id=
        #
        # You must pass `group_id` param
        #
        def index
          orders_frequencies = OrdersFrequency.where(group_id: @group.id)

          render json: OrdersFrequenciesSerializer.new(orders_frequencies)
        end

        # GET /api/v1/orders_frequencies/:id
        #
        def show
          render json: OrdersFrequencySerializer.new(@orders_frequency)
        end

        # POST /api/v1/orders_frequencies
        #
        def create
          orders_frequency = OrdersFrequency.new(
            group: @group,
            ical: orders_frequency_params[:ical],
            frequency_type: frequency_type
          )

          if orders_frequency.save
            render json: OrdersFrequencySerializer.new(orders_frequency)
          else
            render(
              status: :bad_request,
              json: { errors: orders_frequency.errors.messages }
            )
          end
        end

        # PUT /api/v1/orders_frequencies/:id
        #
        def update
          if @orders_frequency.update_attributes(orders_frequency_params)
            render json: OrdersFrequencySerializer.new(@orders_frequency)
          else
            render(
              status: :bad_request,
              json: { errors: @orders_frequency.errors.messages }
            )
          end
        end

        private

        def frequency_type
          input_type = orders_frequency_params[:frequency_type]
          FrequencyType.new(input_type.to_sym).to_s if input_type
        end

        def orders_frequency_params
          params.permit(:group_id, :ical, :frequency_type)
        end

        def load_orders_frequency
          @orders_frequency = OrdersFrequency.find_by_id(params[:id])

          return head :not_found unless @orders_frequency

          authorize @orders_frequency.group
        end

        def load_group
          @group = Group.find_by_id(orders_frequency_params[:group_id])

          return head :not_found unless @group

          authorize @group
        end
      end
    end
  end
end
