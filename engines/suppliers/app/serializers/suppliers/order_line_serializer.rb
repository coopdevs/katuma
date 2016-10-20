module Suppliers
  class OrderLineSerializer < Shared::BaseSerializer
    schema do
      type 'order_line'

      map_properties :id, :order_id, :product_id
    end
  end
end
