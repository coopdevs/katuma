module Group
  class GroupCreator
    attr_accessor :group, :creator, :side_effects

    # @param group [Group]
    # @param creator [User]
    def initialize(group, creator)
      @group = group
      @creator = creator
      @side_effects = []
    end

    # Creates a new Group and adds creator as group admin
    #
    # @return [Group, Membership]
    def create
      ::ActiveRecord::Base.transaction do
        if group.save
          membership = add_creator_as_group_admin
          @side_effects << membership
        end
      end
    end

    private

    # Creates a new Membership for the creator as admin
    #
    # @return [Membership]
    def add_creator_as_group_admin
      group.memberships.create(
        user: creator,
        role: :admin
      )
    end
  end
end
