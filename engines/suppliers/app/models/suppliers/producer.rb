module Suppliers
  class Producer < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :producers

    has_many :memberships, foreign_key: :basic_resource_producer_id
    # TODO: investigate how to scope memberships.role = $admin here
    has_many :groups, through: :memberships

    # @return [Boolean]
    def has_admin?(user)
      memberships.where(
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
