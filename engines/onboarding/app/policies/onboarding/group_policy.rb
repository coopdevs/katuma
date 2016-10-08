module Onboarding
  class GroupPolicy < ::Shared::ApplicationPolicy
    def show?
      Membership.where(
        basic_resource_group_id: record.id,
        user: user
      ).any?
    end

    def invite?
      Membership.where(
        basic_resource_group_id: record.id,
        user: user,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
