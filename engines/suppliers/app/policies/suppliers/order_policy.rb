module Suppliers
  class OrderPolicy < Shared::ApplicationPolicy
    # TODO: check if the user is still a member of the group the order is
    #       pointing to
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
