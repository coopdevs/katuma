module Suppliers
  class Group < ActiveRecord::Base
    include Shared::Model::ReadOnly

    self.table_name = :groups

    has_many :suppliers,
      class_name: 'Suppliers::Supplier'.freeze
    has_many :producers,
      class_name: 'Suppliers::Producer'.freeze,
      through: :suppliers

    has_many :memberships, foreign_key: :basic_resource_group_id

    def has_admin?(user)
      memberships.where(
        role: Membership::ROLES[:admin],
        user_id: user.id
      ).any?
    end
  end
end
