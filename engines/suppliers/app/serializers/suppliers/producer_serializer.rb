module Suppliers
  class ProducerSerializer < Shared::BaseSerializer
    schema do
      type 'producer'

      map_properties :id, :name, :email, :address, :can_edit, :created_at, :updated_at
    end
  end
end
