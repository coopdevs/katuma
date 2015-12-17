module Supplier
  class Order < ActiveRecord::Base
    self.table_name = :orders

    has_many :order_lines, class_name: 'Suppliers::OrderLine'

    belongs_to :user, class_name: 'Suppliers::User'
    belongs_to :group, class_name: 'Suppliers::Group'
  end
end
