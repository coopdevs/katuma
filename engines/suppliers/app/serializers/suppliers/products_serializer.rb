module Suppliers
  class ProductsSerializer < Shared::BaseSerializer
    schema do
      type 'products'

      collection :products, item, ::Products::ProductSerializer
    end
  end
end
