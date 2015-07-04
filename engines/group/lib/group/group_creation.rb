module Group
  class GroupCreation
    attr_accessor :group, :creator

    # @param group [Group]
    # @param creator [Group::User]
    def initialize(group, creator)
      @group = group
      @creator = creator
    end

    # Creates a new Group
    # and add creator as group admin
    def create
      ::Group::Group.transaction do
        if @group.save
          add_creator_as_group_admin
        end
      end
    end

    private

    # Creates a new Membership for the creator
    # as admin
    def add_creator_as_group_admin
      @group.memberships.create(user: @creator, role: Membership::ROLES[:admin])
    end
  end
end
