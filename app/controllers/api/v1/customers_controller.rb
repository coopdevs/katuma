module Api
  module V1
    class CustomersController < ApplicationController

      def index
        render json: Customer.all
      end

      def show
        render json: Customer.find(params[:id])
      end

      def create
        customer = Customer.new(customers_params)
        if customer.save
          render json: customer
        else
          render status: :bad_request,
                 json: {
                   model: customer.class.name,
                   errors: customer.errors.full_messages
                 }
        end
      end

      def update
        customer = Customer.find(params[:id])
        if customer.update_attributes(customers_params)
          render json: customer
        else
          render status: :bad_request,
                 json: {
                   model: customer.class.name,
                   errors: customer.errors.full_messages
                 }
        end
      end

      def destroy
        render json: Customer.destroy(params[:id])
      end

      private

      def customers_params
        params.require(:customer).permit(:name,
                                         waiting_list_attributes: {},
                                         users_units_attributes: [:id, :name, users_attributes: [:name, :email]])
      end

    end
  end
end
