module Suppliers
  class Group < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :groups

    has_many :suppliers,
      class_name: 'Suppliers::Supplier'.freeze
    has_many :producers,
      class_name: 'Suppliers::Producer'.freeze,
      through: :suppliers
  end
end
