module Suppliers
  class Membership < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :memberships

    ROLES = ::Group::Membership::ROLES

    belongs_to :group
    belongs_to :user
  end
end
