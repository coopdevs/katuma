module Suppliers
  class OrdersCollection
    class ToGroup

      # @param user [Suppliers::User]
      # @param params [Hash]
      def initialize(user:, params:)
        @user = user
        @all = params[:all]
        @to_group_id = params[:to_group_id]
        @confirm_before = params[:confirm_before]
      end

      # @return [ActiveRecord::Relation<Order>]
      def build
        context = Order
        context = context.where(from_user_id: user.id) unless all && to_group_id
        context = context.where(to_group_id: to_group_id) if to_group_id
        context = context.where(confirm_before: confirm_before) if confirm_before
        context = context.order(:updated_at)
        context
      end

      private

      attr_reader :user, :to_group_id, :confirm_before, :all
    end
  end
end
