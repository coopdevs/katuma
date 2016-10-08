module BasicResources
  class UsersCollection
    def initialize(group)
      @group = group
    end

    #
    # @return [Array<User>]
    def build
      group_memberships = Membership.where(basic_resource_group_id: group.id)
      User.joins(:memberships).merge(group_memberships)
    end

    private

    attr_reader :group
  end
end
