module Onboarding
  class Group < ActiveRecord::Base

    self.table_name = :groups

    include Shared::Model::ReadOnly

    has_many :invitations,
      dependent: :destroy
  end
end
