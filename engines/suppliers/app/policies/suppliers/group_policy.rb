module Suppliers
  class GroupPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      Membership.where(
        group: record,
        user: user,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def show?
      Membership.where(
        group: record,
        user: user,
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
