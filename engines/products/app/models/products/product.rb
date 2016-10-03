module Products
  class Product < ActiveRecord::Base
    self.table_name = :products

    UNITS = { kg: 0, pc: 1, lt: 2 }.freeze

    belongs_to :producer, class_name: ::BasicResources::Producer

    # TODO: move price to its own table/s
    validates :name, :price, :unit, :producer, presence: true
    validates :unit, inclusion: { in: UNITS.values }
    validates_numericality_of :price, :unit
  end
end
