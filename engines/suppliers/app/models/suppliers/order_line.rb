module Suppliers
  class OrderLine < ActiveRecord::Base
    self.table_name = :order_lines

    belongs_to :order, class_name: 'Suppliers::Order'
    belongs_to :product, class_name: 'Suppliers::Product'
  end
end
