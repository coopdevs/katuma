module BasicResources
  class ProducerCreator
    attr_accessor :producer, :creator, :group, :side_effects

    # @param producer [Producer]
    # @param creator [User]
    # @param group [Group] optional
    def initialize(producer:, creator:, group: nil)
      @producer = producer
      @creator = creator
      @group = group
      @side_effects = []
    end

    # Creates a new Producer
    #
    # @return [Producer]
    def create!
      ::ActiveRecord::Base.transaction do
        if producer.save
          create_membership_for_creator_or_group!
        end
      end

      producer
    end

    private

    # Creates a new Membership for the creator as admin
    #
    # @return [Membership]
    def create_membership_for_creator_or_group!
      membership = Membership.new(
        basic_resource_producer_id: producer.id,
        role: Membership::ROLES[:admin]
      )
      if group
        membership.group = group
      else
        membership.user = creator
      end
      membership.save!

      side_effects << membership
    end
  end
end
