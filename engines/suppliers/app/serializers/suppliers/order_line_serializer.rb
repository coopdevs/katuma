module Suppliers
  class OrderLineSerializer < Shared::BaseSerializer
    schema do
      type 'order_line'

      map_properties :id, :order_id, :product_id, :price, :quantity
      property :updated_at, item.updated_at.to_i
      property :created_at, item.created_at.to_i
    end
  end
end
