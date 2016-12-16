module Suppliers
  class OrderLine < ActiveRecord::Base
    self.table_name = :order_lines

    belongs_to :order, class_name: 'Suppliers::Order'
    belongs_to :product, class_name: 'Suppliers::Product'

    validates :quantity, :price, presence: true
    validates_numericality_of :price
    validates_uniqueness_of :product_id, scope: :order_id
  end
end
