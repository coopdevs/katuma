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
        role: [Role.new(:admin).index, Role.new(:member).index]
      ).any?
    end

    def update?
      Membership.where(
        group: record,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end

    def destroy?
      Membership.where(
        group: record,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end
  end
end
