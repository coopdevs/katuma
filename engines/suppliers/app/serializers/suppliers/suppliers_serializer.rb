module Suppliers
  class SuppliersSerializer < Shared::BaseSerializer
    schema do
      type 'suppliers'
      collection :suppliers, item, SupplierSerializer
    end
  end
end
