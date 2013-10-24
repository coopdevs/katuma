class Product < ActiveRecord::Base
  include Product::Validation

  attr_accessible :description, :measuring_unit, :name

  has_many :order_lines
  has_many :prices
  belongs_to :supplier, :class_name => "Group"

end
