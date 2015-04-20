module Group
  class User < ActiveRecord::Base

    self.table_name = :users

    include Shared::Model::ReadOnly

    has_many :memberships, dependent: :destroy
    has_many :groups, through: :memberships
  end
end
