module BasicResources
  class ProducerPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def update?
      user_admin_membership_for?(user) || group_admin_membership_for?(user)
    end

    def destroy?
      update?
    end

    def create?
      false
    end

    def show?
      false
    end

    def index?
      false
    end

    private

    def user_admin_membership_for?(user)
      Membership.where(
        user_id: user.id,
        basic_resource_producer_id: record.id,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def group_membership_for?(user)
      group_ids = Membership.where(
        user_id: user.id
      ).pluck(:basic_resource_group_id)

      producer_membership_for_groups?(group_ids)
    end

    def group_admin_membership_for?(user)
      group_ids = Membership.where(
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).pluck(:basic_resource_group_id)

      producer_membership_for_groups?(group_ids)
    end

    def producer_membership_for_groups?(group_ids)
      Membership.where(
        group_id: group_ids,
        basic_resource_producer_id: record.id,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
