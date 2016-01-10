module Onboarding
  class GroupPolicy < ::Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      Membership.where(group: record, user: user).any?
    end

    def invite?
      Membership.where(group: record, user: user, role: Membership::ROLES[:admin]).any?
    end
  end
end
