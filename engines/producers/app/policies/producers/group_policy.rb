module Producers
  class GroupPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      ::Group::Membership.where(
        group: record,
        user: user,
        role: ::Group::Membership::ROLES[:admin]
      ).any?
    end

    def show?
      false
    end

    def update?
      false
    end

    def destroy?
      false
    end
  end
end
