class GroupCreation
  attr_accessor :group, :creator

  # @param group [Group]
  # @param creator [User]
  def initialize(group, creator)
    @group = group
    @creator = creator
  end

  # Creates a new Group and a new UsersUnit,
  # add creator as group admin and
  # add creator in UsersUnit.users
  def create
    Group.transaction do
      if self.group.save
        self.add_creator_as_group_admin
        self.add_creator_in_users_unit
      end
    end
  end

  private

  def add_creator_as_group_admin
    @creator.add_role :admin, @group
  end

  def add_creator_in_users_unit
    @group.users_units.last.users << @creator
  end
end
