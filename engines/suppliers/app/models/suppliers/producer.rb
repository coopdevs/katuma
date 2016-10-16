module Suppliers
  class Producer < ::BasicResources::Producer
    include Shared::Model::ReadOnly
  end
end
