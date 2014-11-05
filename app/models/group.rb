class Group < ActiveRecord::Base

  has_one  :profile,
    as: :profilable
  has_many :memberships,
    dependent: :destroy
  has_many :users,
    through: :memberships
  has_many :users_units
  has_many :admins,
    -> { where "memberships.role = #{ Membership::ROLES[:admin] }" },
    through: :memberships,
    source: :user
  has_many :waiters,
    -> { where "memberships.role = #{ Membership::ROLES[:waiting] }" },
    through: :memberships,
    source: :user
  has_many :invitations,
    dependent: :destroy

  validates :name,
    presence: true
end
