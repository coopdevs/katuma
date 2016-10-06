module Suppliers
  module Api
    module V1
      class ProducersController < ApplicationController
        before_action :authenticate
        before_action :load_group,
          only: [:index],
          if: -> { !!params.fetch('group_id', nil) }
        before_action :load_producer, only: [:show]

        # GET /api/v1/producers
        #
        # Without parameters it will return all the producers which the
        # user is associated to directly as a member.
        #
        # Passing `group_id` parameter will return:
        #  - the producers associated to the group through `Membership`
        #  - the producers associated to the group through `Supplier`
        #
        def index
          producers = ProducersCollection.new(user: current_user, group: @group).build

          render json: ::Suppliers::ProducersSerializer.new(producers)
        end

        # GET /api/v1/providers/:id
        #
        def show
          render json: ::Suppliers::ProducerSerializer.new(@producer)
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