module Products
  class ProductsSerializer < Shared::BaseSerializer
    schema do
      type 'products'

      collection :products, item, Producers::ProductSerializer
    end
  end
end
