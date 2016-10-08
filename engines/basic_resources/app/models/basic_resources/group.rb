module BasicResources
  class Group < ActiveRecord::Base

    self.table_name = :groups

    has_many :memberships, dependent: :destroy, foreign_key: :basic_resource_group_id
    has_many :users, through: :memberships

    validates :name, presence: true
  end
end
