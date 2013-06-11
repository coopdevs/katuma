class Order < ActiveRecord::Base
  has_many :order_lines
  belongs_to :customer

  validates :customer_id, :presence => true
end
