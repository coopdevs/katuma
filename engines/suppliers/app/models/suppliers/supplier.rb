module Suppliers
  class Supplier < ActiveRecord::Base
    self.table_name = :suppliers

    belongs_to :group, class_name: 'Suppliers::Group'.freeze
    belongs_to :producer, class_name: 'Suppliers::Producer'.freeze

    validates :producer, :group, presence: true
  end
end

