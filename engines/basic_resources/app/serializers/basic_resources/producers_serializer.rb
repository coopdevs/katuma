module BasicResources
  class ProducersSerializer < Shared::BaseSerializer
    schema do
      type 'producers'

      collection :producers, item, BasicResources::ProducerSerializer
    end
  end
end
