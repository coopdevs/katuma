module Api
  module V1
    class WaitingListsController < ApplicationController

      before_action except: :update do
        @customer = Customer.find(params[:customer_id])
      end

      def show
        render json: @customer.waiting_list
      end

      def create
        waiting_list = @customer.build_waiting_list
        if waiting_list.save
          render json: waiting_list
        else
          render status: :bad_request,
                 json: {
                   model: waiting_list.class.name,
                   errors: waiting_list.errors.full_messages
                 }
        end
      end

      def update
        waiting_list = WaitingList.find(params[:id])
        if waiting_list.update_attributes(waiting_lists_params)
          render json: waiting_list
        else
          render status: :bad_request,
                 json: {
                   model: waiting_list.class.name,
                   errors: waiting_list.errors.full_messages
                 }
        end
      end

      def destroy
        render json: @customer.waiting_list.destroy
      end

      private

      def waiting_lists_params
        params.require(:waiting_list).permit(users_attributes: [:id])
      end
    end
  end
end
