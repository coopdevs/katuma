module Suppliers
  module Api
    module V1
      class SuppliersController < ApplicationController
        before_action :authenticate
        before_action :load_supplier, only: [:show, :update, :destroy]
        before_action :load_group, only: [:index, :create]

        # GET /api/v1/suppliers?group_id=
        #
        # You must pass `group_id` param as filter
        #
        def index
          suppliers = Supplier.where(group_id: @group.id)

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
          supplier = Supplier.new(
            group: @group,
            producer_id: supplier_params[:producer_id]
          )

          if supplier.save
            render json: SupplierSerializer.new(supplier)
          else
            render(
              status: :bad_request,
              json: { errors: supplier.errors.messages }
            )
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
          params.permit(:group_id, :producer_id)
        end

        def load_supplier
          @supplier = Supplier.find_by_id(params[:id])

          return head :not_found unless @supplier

          authorize @supplier.group
        end

        def load_group
          @group = Group.find_by_id(supplier_params[:group_id])

          return head :not_found unless @group

          authorize @group
        end
      end
    end
  end
end
