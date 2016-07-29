module Suppliers
  module Api
    module V1
      class SuppliersController < ApplicationController
        before_action :load_supplier, only: [:show, :update, :destroy]
        before_action :load_group, only: [:index]

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
          @supplier = Supplier::Supplier.new(supplier_params)

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

        def suppliers_params
          params.permit(:group_id)
        end

        def supplier_params
          params.require(:supplier).permit(:id, :group_id, :producer_id)
        end

        def load_supplier
          @supplier = ::Suppliers::Supplier.find_by_id(params[:id])
        end

        def load_group
          @group = ::Suppliers::Group.find_by_id(suppliers_params[:group_id])

          return head :not_found unless @group

          Pundit.policy!(current_user, @group).show?
        end
      end
    end
  end
end
