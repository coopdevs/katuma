module Suppliers
  class Membership < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :memberships

    ROLES = ::BasicResources::Membership::ROLES

    belongs_to :group
    belongs_to :user
    belongs_to :basic_resource_producer,
      class_name: 'Suppliers::Producer'.freeze,
      foreign_key: :basic_resource_producer_id
  end
end
