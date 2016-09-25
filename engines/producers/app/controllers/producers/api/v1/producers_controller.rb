module Producers
  module Api
    module V1
      class ProducersController < ApplicationController
        before_action :load_producer, only: [:show, :update, :destroy]

        # GET /api/v1/producers
        #
        def index
          # no op
        end

        # GET /api/v1/producers/:id
        #
        def show
          render json: ProducerSerializer.new(@producer)
        end

        # POST /api/v1/producers
        #
        def create
          @producer = Producer.new(producer_params)

          if @producer
            render :show
          else
            render :show, status: :bad_request
          end
        end

        # PUT /api/v1/producers/:id
        #
        def update
          if @producer.update_attributes(producer_params)
            render :show
          else
            render :show, status: :bad_request
          end
        end

        # DELETE /api/v1/producers/:id
        #
        def destroy
          if @producer.destroy
            head :no_content
          else
            head :bad_request
          end
        end

        private

        def producer_params
          params.permit(:name, :email, :address)
        end

        def load_producer
          @producer = Producer.find_by_id(params[:id])
        end
      end
    end
  end
end
