module Suppliers
  class ProductsCollection

    # @param user [Suppliers::User]
    # @param group [Suppliers::Group] optional
    # @param producer [Maybe<Suppliers::Producer>] optional
    def initialize(user:, group: nil, producer: nil)
      @user = user
      @group = group
      @producer = producer
    end

    # @return [ActiveRecord::Relation<Product>]
    def relation
      Product.where(producer_id: producer_ids)
    end

    private

    attr_reader :user, :group, :producer

    def producer_ids
      return [producer.id] if producer

      group.suppliers.pluck(:producer_id)
    end
  end
end
