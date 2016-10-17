module Suppliers
  class OrdersFrequenciesSerializer < Shared::BaseSerializer
    schema do
      type 'orders_frequencies'

      collection :orders_frequencies, item, OrdersFrequencySerializer
    end
  end
end
