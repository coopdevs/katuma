module Suppliers
  module Api
    module V1
      class OrdersController < ApplicationController
        before_action :authenticate
        before_action :load_order, only: [:show, :update, :destroy]
        before_action :load_group, only: [:index, :create]

        # GET /api/v1/orders
        #
        # Available parameters:
        #  - to_group_id
        #  - from_group_id
        #  - to_producer_id
        #  - confirm_before
        #  - all
        #
        def index
          orders = OrdersCollection.build(user: current_user, params: orders_params).relation

          render json: OrdersSerializer.new(orders)
        end

        # GET /api/v1/orders/:id
        #
        def show
          render json: OrderSerializer.new(@order)
        end

        # POST /api/v1/orders
        #
        def create
          order = Order.new(
            from_user_id: current_user.id,
            to_group_id: @group.id,
            confirm_before: order_params[:confirm_before]
          )

          if order.save
            render json: OrderSerializer.new(order)
          else
            render(
              status: :bad_request,
              json: { errors: order.errors.messages }
            )
          end
        end

        # PUT /api/v1/orders/:id
        #
        def update
          if @order.update_attributes(order_params)
            render json: OrderSerializer.new(@order)
          else
            render(
              status: :bad_request,
              json: { errors: @order.errors.messages }
            )
          end
        end

        # DELETE /api/v1/orders/:id
        #
        def destroy
          if @order.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def orders_params
          params.permit(:to_group_id, :from_group_id, :to_producer_id, :confirm_before, :all)
        end

        def order_params
          params.permit(:to_group_id, :from_group_id, :to_producer_id, :confirm_before)
        end

        def load_order
          @order = Order.find_by_id(params[:id])

          return head :not_found unless @order

          authorize @order
        end

        def load_group
          return unless params.key?(:to_group_id)

          @group = Group.find_by_id(order_params[:to_group_id])

          return head :not_found unless @group

          authorize @group, :show?
        end
      end
    end
  end
end
