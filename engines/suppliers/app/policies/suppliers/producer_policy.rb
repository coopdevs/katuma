module Suppliers
  class ProducerPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    # TODO: In the future users will be able to create producers directly, not
    #       only through a group. In that case we may want to ask permission
    #       to the producer before some group creates a supplier with them.
    #
    #       For now we'll just check that the user requesting the supplier creation
    #       is an admin of the group, we do that in GroupPolicy `#create?`.
    def create?
      true
    end

    def show?
      group_ids = Membership.where(user: user).pluck(:group_id)

      Supplier.where(
        group: group_ids,
        producer: record
      ).any?
    end

    def update?
      false
    end

    def destroy?
      false
    end
  end
end
