module Products
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    ROLES = ::BasicResources::Membership::ROLES

    include Shared::Model::ReadOnly
  end
end
