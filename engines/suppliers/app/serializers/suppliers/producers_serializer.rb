module Suppliers
  class ProducersSerializer < Shared::BaseSerializer
    schema do
      type 'producers'

      collection :producers, item, ProducerSerializer
    end
  end
end
