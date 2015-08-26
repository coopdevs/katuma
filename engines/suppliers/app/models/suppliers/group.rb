module Suppliers
  class Group < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :groups

    has_many :suppliers, class: 'Suppliers::Supplier'
    has_many :producers, class: 'Suppliers::Producer', through: :suppliers
  end
end
