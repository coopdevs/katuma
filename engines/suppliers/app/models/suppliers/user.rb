module Suppliers
  class User < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :users

    has_many :memberships
    has_many :producers,
      through: :memberships,
      source: :basic_resource_producer,
      class_name: 'Producer'
  end
end
