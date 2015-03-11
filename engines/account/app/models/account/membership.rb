module Account
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    include Shared::Model::ReadOnly

    belongs_to :user
    belongs_to :group
  end
end
