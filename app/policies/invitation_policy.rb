class InvitationPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    Membership.where(group: record.group, user: user, role: Membership::ROLES[:admin]).any?
  end
end
