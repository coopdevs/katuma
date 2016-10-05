module Suppliers
  class Membership < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :memberships

    ROLES = ::BasicResources::Membership::ROLES
  end
end
