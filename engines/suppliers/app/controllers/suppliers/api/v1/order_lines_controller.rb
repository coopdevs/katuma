module Suppliers
  module Api
    module V1
      class OrderLinesController < ApplicationController
        before_action :authenticate
        before_action :load_order, only: [:index]

        # GET /api/v1/order_lines
        #
        # Available parameters:
        #  - order_id (mandatory)
        #
        def index
          order_lines = OrderLine.where(order: @order)

          render json: OrderLinesSerializer.new(order_lines)
        end

        private

        def order_lines_params
          params.permit(:order_id)
        end

        def load_order
          @order = Order.find_by_id(params[:order_id])

          return head :not_found unless @order

          # authorize @order
        end
      end
    end
  end
end
