module Suppliers
  class OrderSerializer < Shared::BaseSerializer
    schema do
      type 'order'

      map_properties :id, :from_user_id, :to_group_id, :from_group_id, :to_producer_id
      property :confirm_before, item.confirm_before.to_i
      property :updated_at, item.updated_at.to_i
      property :created_at, item.created_at.to_i
    end
  end
end
