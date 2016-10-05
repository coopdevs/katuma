module Suppliers
  class User < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :users

    has_many :orders, class_name: 'Suppliers::Order'.freeze
  end
end
