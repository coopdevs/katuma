module Suppliers
  class ProducersCollection

    # @param user [Suppliers::User]
    # @param group [Suppliers::Group]
    def initialize(user:, group:)
      @user = ::BasicResources::User.find(user.id)
      @group = group
    end

    # @return [ActiveRecord::Relation<Producer>]
    def build
      if group
        return Producer.none unless user_member_of_group?

        basic_resources_producer_ids = Membership
          .where(group_id: group.id)
          .pluck(:basic_resource_producer_id)
        producer_ids = Supplier
          .where(group_id: group.id)
          .pluck(:producer_id)

        Producer.where(id: basic_resources_producer_ids + producer_ids)
      else
        user.producers
      end
    end

    private

    attr_reader :user, :group

    # @return [Boolean]
    def user_member_of_group?
      Membership.where(
        basic_resource_group_id: group.id,
        user_id: user.id
      ).any?
    end
  end
end
