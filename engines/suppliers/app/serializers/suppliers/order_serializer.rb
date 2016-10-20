module Suppliers
  class OrderSerializer < Shared::BaseSerializer
    schema do
      type 'order'

      map_properties :id, :from_user_id, :to_group_id, :from_group_id, :to_producer_id,
        :confirm_before, :created_at, :updated_at
    end
  end
end
