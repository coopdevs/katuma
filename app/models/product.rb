class Product < ActiveRecord::Base
  attr_accessible :description, :measuring_unit, :name
end
