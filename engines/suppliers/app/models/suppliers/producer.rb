module Suppliers
  class Producer < ::BasicResources::Producer
    include Shared::Model::ReadOnly

    self.table_name = :producers
  end
end
