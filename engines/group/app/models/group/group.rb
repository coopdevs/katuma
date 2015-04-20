module Group
  class Group < ActiveRecord::Base

    self.table_name = :groups

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    has_many :admins,
      -> { where "memberships.role = #{ Membership::ROLES[:admin] }" },
    through: :memberships,
      source: :user
    has_many :waiters,
      -> { where "memberships.role = #{ Membership::ROLES[:waiting] }" },
    through: :memberships,
      source: :user

    validates :name, presence: true
  end
end
