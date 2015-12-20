module Producers
  class ProducerCreator
    attr_accessor :producer, :creator, :group, :side_effects

    # @param producer [Producer]
    # @param creator [User]
    # @param group [Group]
    def initialize(producer, creator, group)
      @producer = producer
      @creator = creator
      @group = group
      @side_effects = []
    end

    # Creates a new Producer and adds creator as producer admin
    #
    # @return [Producer, Supplier]
    def create
      ::ActiveRecord::Base.transaction do
        if producer.save
          supplier = add_provider_as_group_supplier
          @side_effects << supplier
        end
      end
    end

    private

    # Adds the provider as a supplier to the given group
    #
    # @return [Supplier]
    def add_provider_as_group_supplier
      return unless group

      group.suppliers.create(
        producer_id: producer.id
      )
    end
  end
end
