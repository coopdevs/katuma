module Suppliers
  class SupplierSerializer < Shared::BaseSerializer
    schema do
      type 'supplier'
      map_properties :id, :group_id, :producer_id, :created_at, :updated_at
    end
  end
end
