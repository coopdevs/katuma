module Suppliers
  module OrdersCollection

    module_function

    # @param user [Suppliers::User]
    # @param params [Hash]
    def self.build(user:, params:)
      return ToProducer.new(user: user, params: params) if params[:to_producer_id]

      ToGroup.new(user: user, params: params)
    end
  end
end
