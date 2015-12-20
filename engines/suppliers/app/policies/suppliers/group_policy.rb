module Suppliers
  class GroupPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      false
    end

    def show?
      Membership.where(
        group: record,
        user: user,
        role: [Membership::ROLES[:admin], Membership::ROLES[:member]]
      ).any?
    end

    def update?
      false
    end

    def destroy?
      false
    end

    def add_supplier?
      Membership.where(
        group: record,
        user: user,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
