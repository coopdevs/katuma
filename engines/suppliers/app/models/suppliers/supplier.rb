module Suppliers
  class Supplier < ActiveRecord::Base
    self.table_name = :suppliers

    belongs_to :group, class_name: 'Suppliers::Group'
    belongs_to :producer, class_name: 'Suppliers::Producer'

    validates :producer, :group, presence: true
  end
end

