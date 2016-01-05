module Onboarding
  class InvitationPolicy < ::Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      Membership.where(
        group: record.group,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end
  end
end
