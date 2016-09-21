module Suppliers
  class ProvidersSerializer < Shared::BaseSerializer
    schema do
      type 'providers'

      collection :providers, item, ProviderSerializer
    end
  end
end
