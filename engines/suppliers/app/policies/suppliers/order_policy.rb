module Suppliers
  class OrderPolicy < Shared::ApplicationPolicy
    def show?
      record.from_user_id == user.id
    end

    def create?
      false
    end

    def update?
      show?
    end

    def destroy?
      show?
    end
  end
end
