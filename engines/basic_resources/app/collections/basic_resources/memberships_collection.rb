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
    # all of them. Note however, that if the user is admin of a group, all
    # memberships of his groups will be returned.
    #
    # @return [ActiveRecord::Relation<Membership>]
    def build
      if admin_in_some_group?
        Membership.where(basic_resource_group_id: user.group_ids)
      else
        relation = Membership.where(user_id: user.id)
        relation = relation.where(basic_resource_group_id: group.id) if group
        relation
      end
    end

    private

    attr_reader :group, :user

    # Checks whether the user is admin in any group
    #
    # @return [Boolean]
    def admin_in_some_group?
      Membership.where(user: user, role: MemberRole.new(:admin)).any?
    end
  end
end
