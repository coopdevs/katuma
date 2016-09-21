module Suppliers
  class Producer < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :producers
  end
end

