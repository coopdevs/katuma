module Supplier
  class OrderLine < ActiveRecord::Base
    belongs_to :order, class_name: 'Suppliers::Order'
    belongs_to :product, class_name: 'Suppliers::Product'
  end
end
