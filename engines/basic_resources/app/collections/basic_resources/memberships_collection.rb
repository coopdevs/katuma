module BasicResources
  class MembershipsCollection

    # Constructor
    #
    # @param user [User]
    # @param group [Group]
    def initialize(user, group)
      @user = user
      @group = group
    end

    # Returns the memberships either scoped by the user or the given group.
    #
    # Passing no filters it returns all the memberships of the user in any `Group` or `Producer`.
    #
    # Passing a not nil `group` will return all the memberships associated to the
    # specified `Group`.
    #
    # @return [ActiveRecord::Relation<Membership>]
    def build
      return Membership.where(basic_resource_group_id: group.id) if group

      Membership.where(user_id: user.id)
    end

    private

    attr_reader :group, :user
  end
end
