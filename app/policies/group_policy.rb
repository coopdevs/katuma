class GroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def show?
    user.has_role? :admin, record
  end

  def update?
    user.has_role? :admin, record
  end

  def destroy?
    user.has_role? :admin, record
  end
end
