module Suppliers
  class ProducerPolicy < Shared::ApplicationPolicy
    def show?
      user_is_member_of_producer? ||
        user_is_member_through_group? ||
        producer_is_provider_of_any_group?
    end

    def create?
      false
    end

    def update?
      false
    end

    def destroy?
      false
    end

    private

    def user_is_member_of_producer?
      Membership.where(
        user_id: user.id,
        basic_resource_producer_id: record.id
      ).any?
    end

    def user_is_member_through_group?
      group_ids = Membership.where(basic_resource_producer_id: record.id).pluck(:group_id)

      Membership.where(user_id: user.id, basic_resource_group_id: group_ids).any?
    end

    def producer_is_provider_of_any_group?
      group_ids = Membership.where(user_id: user.id).pluck(:basic_resource_group_id)

      Supplier.where(
        group: group_ids,
        producer: record
      ).any?
    end
  end
end
