class WaitingUserPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    user.has_role? :admin, record.group
  end

  def create?
    user.has_role? :admin, record.group
  end

  def destroy?
    user.has_role? :admin, record.group
  end
end
