module Suppliers
  module OrdersCollection
    class ToProducer

      # @param user [Suppliers::User]
      # @param params [Hash]
      def initialize(user:, params:)
        @user = user
        @from_group_id = params[:from_group_id]
        @to_producer_id = params[:to_producer_id]
        @confirm_before = params[:confirm_before]
      end

      # TODO: maybe scope to user's producers when no params are passed in
      #
      # @return [ActiveRecord::Relation<Order>]
      def relation
        context = Order
        context = context.where(from_group_id: from_group_id) if from_group_id
        context = context.where(to_producer_id: to_producer_id) if to_producer_id
        context = context.where(confirm_before: confirm_before) if confirm_before
        context = context.order(:updated_at)
        context
      end

      private

      attr_reader :user, :from_group_id, :to_producer_id, :confirm_before
    end
  end
end
