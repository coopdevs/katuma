module Suppliers
  class SuppliersFinder

    def initialize(group_id)
      @group_id = group_id
    end

    def find
      Supplier.where(group_id: group_id)
    end

    private

    attr_reader :group_id
  end
end
