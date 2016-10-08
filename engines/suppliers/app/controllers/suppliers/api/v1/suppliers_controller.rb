module Suppliers
  module Api
    module V1
      class SuppliersController < ApplicationController
        before_action :authenticate
        before_action :load_supplier, only: [:show, :update, :destroy]
        before_action :load_group, only: [:index, :create]
        before_action :load_producer, only: [:create]

        # GET /api/v1/suppliers
        #
        # You must pass `group_id` param as filter
        #
        # TODO: Deal better with finders, filters and collections
        #
        def index
          suppliers = ::Suppliers::Supplier.where(group_id: @group.id)

          render json: ::Suppliers::SuppliersSerializer.new(suppliers)
        end

        # GET /api/v1/suppliers/:id
        #
        def show
          render json: ::Suppliers::SupplierSerializer.new(@supplier)
        end

        # POST /api/v1/suppliers
        #
        def create
          supplier = Supplier.new(
            group: @group,
            producer: @producer
          )

          if supplier.valid? && supplier.save
            render json: SupplierSerializer.new(supplier)
          else
            render(
              status: :bad_request,
              json: supplier.errors
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
          @group = ::Suppliers::Group.find_by_id(supplier_params[:group_id])

          return head :not_found unless @group

          authorize @group
        end

        def load_producer
          @producer = ::Suppliers::Producer.find_by_id(supplier_params[:producer_id])

          return head :not_found unless @producer

          authorize @producer
        end
      end
    end
  end
end
