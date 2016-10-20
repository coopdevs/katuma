module Products
  module Api
    module V1
      class ProductsController < ApplicationController
        before_action :authenticate
        before_action :load_product, only: [:show, :update, :destroy]
        before_action :load_producer, only: [:create]

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
            render json: ProductSerializer.new(@product)
          else
            render(
              status: :bad_request,
              json: @product.errors.to_json
            )
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

        def load_product
          @product = Product.find_by_id(params[:id])

          return head :not_found unless @product

          authorize @product
        end

        def load_producer
          @producer = Producer.find_by_id(product_params[:producer_id])

          return head :not_found unless @producer

          authorize @producer
        end
      end
    end
  end
end
