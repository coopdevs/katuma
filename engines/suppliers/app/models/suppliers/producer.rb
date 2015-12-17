module Suppliers
  class Producer < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :producers

    has_many :suppliers, class_name: 'Suppliers::Supplier'
    has_many :groups, class_name: 'Suppliers::Group', through: :suppliers
  end
end

