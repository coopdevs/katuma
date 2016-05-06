module Suppliers
  class SuppliersFinder

    def initialize(user, group_id = nil)
      @group_id = group_id
      @user = user
    end

    def find
      if group_id
        suppliers_of_group
      else
        suppliers_in_users_groups
      end
    end

    private

    attr_reader :group_id, :user

    def suppliers_in_users_groups
      group_ids = Membership.group_ids_of(user)
      ::Suppliers::Supplier.where(group_id: group_ids)
    end

    def suppliers_of_group
      ::Suppliers::Supplier.where(group_id: group_id)
    end
  end
end
