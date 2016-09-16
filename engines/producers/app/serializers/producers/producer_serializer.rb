module Producers
  class ProducerSerializer < Shared::BaseSerializer
    schema do
      type 'producer'

      map_properties :id, :name, :email, :address, :created_at, :updated_at
    end
  end
end
