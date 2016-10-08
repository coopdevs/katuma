module BasicResources
  # Fetches the list of memberships that belong to the user, in the given group
  # if specified. All the memberships that belong to the user are returned,
  # otherwise.
  class MembershipsCollection

    # Constructor
    #
    # @param user [User]
    # @param group [Group]
    def initialize(user, group)
      @user = user
      @group = group
    end

    # Returns the memberships of the user either scoped by the given group or
    # all of them
    #
    # @return [ActiveRecord::Relation<Membership>]
    def build
      relation = Membership.where(user_id: user.id)
      relation = relation.where(basic_resource_group_id: group.id) if group
      relation
    end

    private

    attr_reader :group, :user
  end
end
