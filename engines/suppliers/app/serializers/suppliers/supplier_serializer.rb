module Suppliers
  class SupplierSerializer < Shared::BaseSerializer
    schema do
      type 'supplier'
      map_properties :id, :group_id, :producer_id
    end
  end
end
