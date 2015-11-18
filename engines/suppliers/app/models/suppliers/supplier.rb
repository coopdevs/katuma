module Supplier
  class Supplier < ActiveRecord::Base
    self.table_name = :suppliers

    belongs_to :group, class: 'Suppliers::Group'
    belongs_to :producer, class: 'Suppliers::Producer'
  end
end

