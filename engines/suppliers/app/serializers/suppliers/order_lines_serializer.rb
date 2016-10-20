module Suppliers
  class OrderLinesSerializer < Shared::BaseSerializer
    schema do
      type 'order_lines'

      collection :order_lines, item, OrderLineSerializer
    end
  end
end
