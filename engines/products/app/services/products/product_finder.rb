module Products
  class ProductFinder

    # Returns all the products associated with a given producer
    #
    # @param producer [Producers::Producer]
    # @return [ActiveRecord::Relation<Producers::Product>]
    def find_by_producer(producer)
      Product.where(producer_id: producer.id)
    end
  end
end
