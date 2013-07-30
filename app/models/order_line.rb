class OrderLine < ActiveRecord::Base
  attr_accessible :price, :quantity, :product, :order

  has_many :child_order_lines, :class_name => "OrderLine"
  belongs_to :order
  belongs_to :product

  validates :price, :quantity, :presence => true
  validates :order_id, :product_id, :presence => true
end
