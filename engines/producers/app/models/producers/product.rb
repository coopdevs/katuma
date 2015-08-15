module Producers
  class Product < ActiveRecord::Base
    self.table_name = :products

    belongs_to :provider

    enum unit: [:kg, :pc, :lt]
  end
end
