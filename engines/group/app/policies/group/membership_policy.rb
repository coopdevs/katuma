module Group
  class MembershipPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def index?
      true
    end

    def show?
      Membership.where(group: record.group, user: user).any?
    end

    def create?
      Membership.where(group: record.group, user: user, role: Membership::ROLES[:admin]).any?
    end

    def update?
      Membership.where(group: record.group, user: user, role: Membership::ROLES[:admin]).any?
    end

    def destroy?
      Membership.where(group: record.group, user: user, role: Membership::ROLES[:admin]).any?
    end
  end
end
