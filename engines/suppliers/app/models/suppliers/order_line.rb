module Supplier
  class OrderLine < ActiveRecord::Base
    belongs_to :order, class: 'Suppliers::Order'
    belongs_to :product, class: 'Suppliers::Product'
  end
end
