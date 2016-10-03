module Products
  class ProductsSerializer < Shared::BaseSerializer
    schema do
      type 'products'

      collection :products, item, ProductSerializer
    end
  end
end
