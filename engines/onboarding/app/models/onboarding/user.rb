module Onboarding
  class User < ActiveRecord::Base

    self.table_name = :users

    include Shared::Model::ReadOnly

    has_many :memberships
    has_many :groups,
      through: :memberships
    has_many :invitations,
      foreign_key: :invited_by,
      dependent: :destroy # How this works in CBRA?
  end
end
