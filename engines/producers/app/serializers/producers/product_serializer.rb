module Producers
  class ProductSerializer < Shared::BaseSerializer
    schema do
      type 'product'

      map_properties :id, :name, :price, :unit, :producer_id
    end
  end
end
