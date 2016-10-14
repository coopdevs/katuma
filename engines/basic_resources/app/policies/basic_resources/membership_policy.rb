module BasicResources
  class MembershipPolicy < Shared::ApplicationPolicy
    def index?
      true
    end

    def show?
      Membership.where(
        basic_resource_group_id: record.basic_resource_group_id,
        user_id: user.id
      ).any?
    end

    def create?
      false
    end

    def update?
      Membership.where(
        basic_resource_group_id: record.basic_resource_group_id,
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def destroy?
      Membership.where(group: record.group, user: user, role: Membership::ROLES[:admin]).any?
    end
  end
end
