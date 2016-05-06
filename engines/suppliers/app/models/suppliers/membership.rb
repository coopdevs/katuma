module Suppliers
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    include Shared::Model::ReadOnly

    def self.group_ids_of(user_id)
      where(user_id: user_id).pluck(:group_id)
    end
  end
end
