module Products
  class ProductSerializer < Shared::BaseSerializer
    schema do
      type 'product'

      map_properties :id, :name, :price, :unit, :producer_id
      property :updated_at, item.updated_at.to_i
      property :created_at, item.created_at.to_i
    end
  end
end
