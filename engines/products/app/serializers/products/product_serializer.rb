module Products
  class ProductSerializer < Shared::BaseSerializer
    schema do
      type 'product'

      map_properties :id, :name, :price, :unit, :producer_id, :created_at, :updated_at
    end
  end
end
