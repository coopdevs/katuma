module Suppliers
  module Api
    module V1
      class SuppliersController < ApplicationController
        before_action :load_supplier, only: [:show, :update, :destroy]

        # GET /api/v1/suppliers
        #
        def index
          suppliers = SuppliersFinder.new(supplier_params[:group_id]).find
          render json: SuppliersSerializer.new(suppliers)
        end

        # GET /api/v1/suppliers/:id
        #
        def show
          render json: SupplierSerializer.new(@supplier)
        end

        # POST /api/v1/suppliers
        #
        def create
          @supplier = Supplier.new(supplier_params)

          if @supplier
            render :show
          else
            render :show, status: :bad_request
          end
        end

        # PUT /api/v1/suppliers/:id
        #
        def update
          if @supplier.update_attributes(supplier_params)
            render :show
          else
            render :show, status: :bad_request
          end
        end

        # DELETE /api/v1/suppliers/:id
        #
        def destroy
          if @supplier.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def supplier_params
          params.permit(:id, :group_id, :producer_id)
        end

        def load_supplier
          @supplier = Supplier.find_by_id(params[:id])
        end
      end
    end
  end
end
