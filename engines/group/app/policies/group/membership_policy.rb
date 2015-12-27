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

    def create?
      Membership.where(
        group: record.group,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end

    def update?
      Membership.where(
        group: record.group,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end

    def destroy?
      Membership.where(
        group: record.group,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end
  end
end
