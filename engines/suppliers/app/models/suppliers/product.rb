module Suppliers
  class Product < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :products

    belongs_to :producer, class_name: 'Suppliers::Producer'
  end
end
