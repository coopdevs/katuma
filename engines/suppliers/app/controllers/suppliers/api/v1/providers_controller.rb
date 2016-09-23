module Suppliers
  module Api
    module V1
      class ProvidersController < ApplicationController
        before_action :authenticate
        before_action :load_group, only: [:index]
        before_action :load_producer, only: [:show]

        # GET /api/v1/providers?group_id=
        #
        # You must pass `group_id` param as filter
        #
        def index
          producer_ids = ::Suppliers::Supplier.where(group_id: @group.id).pluck(:producer_id)
          providers = ::Suppliers::Producer.where(id: producer_ids)

          render json: ::Suppliers::ProvidersSerializer.new(providers)
        end

        # GET /api/v1/providers/:id
        #
        def show
          render json: ::Suppliers::ProviderSerializer.new(@producer)
        end

        private

        def load_group
          @group = ::Suppliers::Group.find_by_id(params[:group_id])

          return head :not_found unless @group

          authorize @group
        end

        def load_producer
          @producer = ::Suppliers::Producer.find_by_id(params[:id])

          return head :not_found unless @producer

          authorize @producer
        end
      end
    end
  end
end
