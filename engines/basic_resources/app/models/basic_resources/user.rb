module BasicResources
  class User < ActiveRecord::Base

    self.table_name = :users

    include Shared::Model::ReadOnly

    has_many :memberships, dependent: :destroy
    has_many :groups, through: :memberships, source: :basic_resource_group
    has_many :producers, through: :memberships, source: :basic_resource_producer
  end
end
