# app/models/concerns/validation.rb
class Product
  module Validation
    extend ActiveSupport::Concern

    included do
      validates :name, :measuring_unit, :presence => true
    end
  end
end
