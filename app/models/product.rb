class Product < ActiveRecord::Base
  has_many :order_lines
  has_many :prices
  belongs_to :supplier, :class_name => "Group"

  validates :name, :measuring_unit, :presence => true
end
