class Price < ActiveRecord::Base
  attr_accessible :name, :price

  belongs_to :product
  belongs_to :customer, :class_name => "Group"

  validates :name, :price, :product_id, :presence => true
end
