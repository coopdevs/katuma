class Price < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer, :class_name => "Group"

  validates :name, :price, :product_id, :presence => true
end
