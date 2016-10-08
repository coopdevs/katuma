module Group
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    ROLES = { admin: 1, member: 2, waiting: 3 }.freeze

    belongs_to :group
    belongs_to :user, class_name: 'Group::User'.freeze

    validates :group, :user, :role, presence: true
    validates :role, inclusion: { in: ROLES.values }
    validates :user_id, uniqueness: { scope: :group_id }
  end
end