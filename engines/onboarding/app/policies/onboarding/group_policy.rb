module Onboarding
  class GroupPolicy < ::Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def bulk?
      Membership.where(
        group: record,
        user: user,
        role: Role.new(:admin).index
      ).any?
    end
  end
end
