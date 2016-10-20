module Suppliers
  class OrdersSerializer < Shared::BaseSerializer
    schema do
      type 'orders'

      collection :orders, item, OrderSerializer
    end
  end
end
