module Suppliers
  class GroupPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      Membership.where(
        basic_resource_group_id: record.id,
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def show?
      Membership.where(
        basic_resource_group_id: record.id,
        user_id: user.id,
        role: [Membership::ROLES[:admin], Membership::ROLES[:member]]
      ).any?
    end

    def index?
      show?
    end

    def update?
      false
    end

    def destroy?
      create?
    end
  end
end
