module Suppliers
  class ProviderSerializer < Shared::BaseSerializer
    schema do
      type 'provider'

      map_properties :id, :name, :email, :address, :created_at, :updated_at
    end
  end
end
