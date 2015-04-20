module Group
  class GroupPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      true
    end

    def show?
      Membership.where(
        group: record,
        user: user,
        role: [Membership::ROLES[:admin], Membership::ROLES[:member]]
      ).any?
    end

    def update?
      Membership.where(group: record, user: user, role: Membership::ROLES[:admin]).any?
    end

    def destroy?
      Membership.where(group: record, user: user, role: Membership::ROLES[:admin]).any?
    end
  end
end
