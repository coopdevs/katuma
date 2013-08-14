class OrderLine < ActiveRecord::Base
  attr_accessible :price, :quantity, :product, :order

  has_many :child_order_lines, :class_name => "OrderLine"
  belongs_to :order
  belongs_to :product

  validates :price, :quantity, :presence => true
  validates :order_id, :product_id, :presence => true
  validate :child_order_line_is_not_self, :on => :update

  # Check for self reference
  def child_order_line_is_not_self
    if self.id == order_line_id
      errors.add(:order_line, "can't reference self as parent order line")
    end
  end

end
