module Producers
  class ProducerPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      false
    end

    # TODO: add `Producer::Membership` condition
    def show?
      # TODO: find a better way to deal with dependencies
      #       we're making the User query twice here :scream:
      group_user = ::Group::User.find(user.id)

      supplier_ids = ::Suppliers::Supplier.where(
        group_id: group_user.group_ids,
        producer_id: record.id
      ).pluck(:id)

      supplier_ids.any?
    end

    def update?
      false
    end

    def destroy?
      false
    end
  end
end
