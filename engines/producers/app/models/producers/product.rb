module Producers
  class Product < ActiveRecord::Base
    self.table_name = :products

    belongs_to :provider

    enum unit: {
      kg: 0,
      pc: 1,
      lt: 2
    }

    # TODO: move price to its own table/s
    validates :name, :price, :unit, presence: true
  end
end
