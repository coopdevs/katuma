module Supplier
  class Order < ActiveRecord::Base
    self.table_name = :orders

    has_many :order_lines, class: 'Suppliers::OrderLine'

    belongs_to :user, class: 'Suppliers::User'
    belongs_to :group, class: 'Suppliers::Group'
  end
end
