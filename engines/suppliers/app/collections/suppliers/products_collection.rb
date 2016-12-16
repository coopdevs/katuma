module Suppliers
  class ProductsCollection

    class GroupNotPresent < ArgumentError; end

    # At least one of `group` or `producer` should be passed
    #
    # @param group [Suppliers::Group] optional
    # @param producer [Maybe<Suppliers::Producer>] optional
    def initialize(group: nil, producer: nil)
      @group = group
      @producer = producer
    end

    # @return [ActiveRecord::Relation<Product>]
    def relation
      Product.where(producer_id: producer_ids)
    end

    private

    attr_reader :group, :producer

    # Returns an array of the producer ids related to a given group
    #
    # We need to look for unscoped `suppliers` since by default we return
    # all the products that a group could order along with all the products
    # that a group could have ordered to a producer that was a supplier in the past.
    #
    # If a `producer` is provided it returns an array with the given `producer` id
    #
    # @return [Array<Integer>]
    def producer_ids
      return [producer.id] if producer

      raise GroupNotPresent, 'You must specify a group or a producer' unless group

      group
        .suppliers
        .unscoped
        .pluck(:producer_id)
    end
  end
end
