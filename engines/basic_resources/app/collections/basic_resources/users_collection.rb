module BasicResources
  # Fetches the list of users that belong to the given group
  class UsersCollection

    # Constructor
    #
    # @param group [Group]
    def initialize(group)
      @group = group
    end

    # Returns the list of users that belong to the group
    #
    # @return [ActiveRecord::Relation<User>]
    def build
      group_memberships = Membership.where(basic_resource_group_id: group.id)
      User.joins(:memberships).merge(group_memberships)
    end

    private

    attr_reader :group
  end
end
