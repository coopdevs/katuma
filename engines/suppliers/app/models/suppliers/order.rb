module Supplier
  class Order < ActiveRecord::Base
    self.table_name = :orders

    has_many :order_lines, class_name: 'Suppliers::OrderLine'.freeze

    belongs_to :user, class_name: 'Suppliers::User'.freeze
    belongs_to :group, class_name: 'Suppliers::Group'.freeze
  end
end
