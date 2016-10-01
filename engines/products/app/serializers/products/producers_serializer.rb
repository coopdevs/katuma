module Products
  class ProducersSerializer < Shared::BaseSerializer
    schema do
      type 'producers'

      collection :producers, item, Producers::ProducerSerializer
    end
  end
end
