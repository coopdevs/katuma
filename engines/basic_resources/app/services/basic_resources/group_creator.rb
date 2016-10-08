module BasicResources
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
    # @return [Group]
    def create
      ::ActiveRecord::Base.transaction do
        if group.save!
          membership = add_creator_as_group_admin!
          @side_effects << membership
        end
      end
    rescue ActiveRecord::RecordInvalid => _exception
      raise if group.valid?
      group
    end

    private

    # Creates a new Membership for the creator as admin
    #
    # @return [Membership]
    def add_creator_as_group_admin!
      Membership.create!(
        basic_resource_group_id: group.id,
        user: creator,
        role: ::BasicResources::Membership::ROLES[:admin]
      )
    end
  end
end
