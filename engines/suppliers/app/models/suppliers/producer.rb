module Suppliers
  class Producer < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :producers

    has_many :suppliers, class: 'Suppliers::Supplier'
    has_many :groups, class: 'Suppliers::Group', through: :suppliers
  end
end

