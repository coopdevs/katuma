module Supplier
  class Product < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :products
  end
end
