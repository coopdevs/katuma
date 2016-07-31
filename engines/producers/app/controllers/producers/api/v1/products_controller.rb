module Producers
  module Api
    module V1
      class ProductsController < ApplicationController
        before_action :load_product, only: [:show, :update, :destroy]
        before_action :load_producer, only: [:index, :create]

        # GET /api/v1/products
        #
        # You must pass `producer_id` param as filter
        #
        def index

          products = ProductsFinder.find_by_producer(@producer)

          render json: ProductsSerializer.new(products)
        end

        # GET /api/v1/products/:id
        #
        def show
          render json: ProductSerializer.new(@product)
        end

        # POST /api/v1/products
        #
        def create
          product = Product.new(product_params)

          if product.save
            render json: ProductSerializer.new(product)
          else
            render(
              status: :bad_request,
              json: product.errors.to_json
            )
          end
        end

        # PUT /api/v1/products/:id
        #
        def update
          if @product.update_attributes(product_params)
            render :show
          else
            render :show, status: :bad_request
          end
        end

        # DELETE /api/v1/products/:id
        #
        def destroy
          if @product.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def product_params
          params.permit(:name, :price, :unit, :producer_id)
        end

        def products_params
          params.permit(:producer_id)
        end

        def load_product
          @product = Product.find_by_id(params[:id])
        end

        def load_producer
          @producer = Producer.find_by_id(products_params[:producer_id])

          return head :not_found unless @producer

          ::Pundit.authorize(current_user, @producer, :show?)
        end
      end
    end
  end
end
