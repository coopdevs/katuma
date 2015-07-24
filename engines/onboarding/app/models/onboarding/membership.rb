module Onboarding
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    ROLES = { admin: 1, member: 2, waiting: 3 }

    include Shared::Model::ReadOnly

    belongs_to :user
    belongs_to :group
  end
end
