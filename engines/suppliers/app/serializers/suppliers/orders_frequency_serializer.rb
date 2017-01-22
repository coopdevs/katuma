module Suppliers
  class OrdersFrequencySerializer < Shared::BaseSerializer
    schema do
      type 'orders_frequency'

      map_properties :id, :group_id, :frequency_type, :created_at, :updated_at
      property :to_ical, item.ical
    end
  end
end
