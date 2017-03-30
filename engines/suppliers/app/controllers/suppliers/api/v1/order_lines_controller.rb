module Suppliers
  module Api
    module V1
      class OrderLinesController < ApplicationController
        before_action :authenticate
        before_action :load_order_line, only: [:update, :destroy]
        before_action :load_order, only: [:index, :create]
        before_action :load_product, only: [:create]

        # GET /api/v1/order_lines
        #
        # Available parameters:
        #  - order_id (mandatory)
        #
        def index
          order_lines = OrderLine.where(order: @order)

          render json: OrderLinesSerializer.new(order_lines)
        end

        # POST /api/v1/order_lines
        #
        def create
          order_line = OrderLine.new(
            order_id: @order.id,
            product_id: @product.id,
            quantity: order_line_params[:quantity]
          )

          if order_line.save
            render json: OrderLineSerializer.new(order_line)
          else
            render(
              status: :bad_request,
              json: { errors: order_line.errors.messages }
            )
          end
        end

        # PUT /api/v1/order_lines/:id
        #
        def update
          if @order_line.update_attributes(order_line_params)
            render json: OrderLineSerializer.new(@order_line)
          else
            render(
              status: :bad_request,
              json: { errors: @order_line.errors.messages }
            )
          end
        end

        # DELETE /api/v1/order_lines/:id
        #
        def destroy
          if @order_line.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def order_line_params
          params.permit(:order_id, :product_id, :quantity)
        end

        def load_order_line
          @order_line = OrderLine.find_by_id(params[:id])

          return head :not_found unless @order_line

          authorize @order_line.order
        end

        def load_order
          @order = Order.find_by_id(params[:order_id])

          return head :not_found unless @order

          authorize @order, :show?
        end

        def load_product
          @product = Product.find_by_id(params[:product_id])

          return head :not_found unless @product

          authorize @product.producer, :show?
        end
      end
    end
  end
end
