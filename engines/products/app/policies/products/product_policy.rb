module Products
  # TODO: Looks like it has no tests
  class ProductPolicy < Shared::ApplicationPolicy
    def create?
      edit?
    end

    def update?
      edit?
    end

    def destroy?
      edit?
    end

    def show?
      user_membership_for?(user) || group_membership_for?(user)
    end

    private

    # Checks whether the user can edit the product
    #
    # @return [Boolean]
    def edit?
      producer_admin_for?(user) || group_admin_for?(user)
    end

    def user_membership_for?(user)
      Membership.where(
        user_id: user.id,
        basic_resource_producer_id: record.producer_id
      ).any?
    end

    # Producer admin
    def producer_admin_for?(user)
      Membership.where(
        user_id: user.id,
        basic_resource_producer_id: record.producer_id,
        role: Membership::ROLES[:admin]
      ).any?
    end

    def group_membership_for?(user)
      group_ids = Membership.where(
        user_id: user.id
      ).pluck(:basic_resource_group_id)

      producers_created_by?(group_ids)
    end

    # Group admin
    def group_admin_for?(user)
      group_ids = Membership.where(
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).pluck(:basic_resource_group_id)

      producers_created_by?(group_ids)
    end

    # Producers created by those groups
    def producers_created_by?(group_ids)
      Membership.where(
        group_id: group_ids,
        basic_resource_producer_id: record.producer_id,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
