module Products
  class ProducerPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      user_admin_membership_for?(user) || group_admin_membership_for?(user)
    end

    def show?
      user_membership_for?(user) || group_membership_for?(user)
    end

    def update?
      user_admin_membership_for?(user) || group_admin_membership_for?(user)
    end

    def destroy?
      user_admin_membership_for?(user) || group_admin_membership_for?(user)
    end

    def index?
      show?
    end

    private

    def user_membership_for?(user)
      Membership.where(
        user_id: user.id,
        producer_id: record.id
      ).any?
    end

    def user_admin_membership_for?(user)
      Membership.where(
        user_id: user.id,
        producer_id: record.id,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def group_membership_for?(user)
      group_ids = ::Group::Membership.where(
        user_id: user.id
      ).pluck(:group_id)

      producer_membership_for_groups?(group_ids)
    end

    def group_admin_membership_for?(user)
      group_ids = ::Group::Membership.where(
        user_id: user.id,
        role: ::Group::Membership::ROLES[:admin]
      ).pluck(:group_id)

      producer_membership_for_groups?(group_ids)
    end

    def producer_membership_for_groups?(group_ids)
      Membership.where(
        group_id: group_ids,
        producer_id: record.id,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end