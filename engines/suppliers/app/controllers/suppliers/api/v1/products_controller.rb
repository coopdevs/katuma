module Suppliers
  module Api
    module V1
      class ProductsController < ApplicationController
        before_action :authenticate
        before_action :validate_params

        # GET /api/v1/products
        #
        # Available parameters:
        #  - group_id
        #  - producer_id
        #
        def index
          load_group if products_params[:group_id]
          load_producer if products_params[:producer_id]

          products = ProductsCollection.new(user: current_user, group: @group, producer: @producer).relation

          render json: ProductsSerializer.new(products)
        end

        private

        def products_params
          params.permit(:group_id, :producer_id)
        end

        def validate_params
          return head :bad_request unless products_params[:group_id] || products_params[:producer_id]
        end

        def load_group
          @group = Group.find_by_id(products_params[:group_id])

          return head :not_found unless @group

          authorize @group, :show?
        end

        def load_producer
          @producer = Producer.find_by_id(products_params[:producer_id])

          return head :not_found unless @producer

          authorize @producer, :show?
        end
      end
    end
  end
end
