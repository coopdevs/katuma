class Group < ActiveRecord::Base

  has_one  :profile,
    as: :profilable
  has_many :memberships,
    dependent: :destroy
  has_many :users,
    through: :memberships
  has_many :users_units
  has_many :waiters,
    -> { where "memberships.role = #{ Membership::ROLES[:waiting] }" },
    through: :memberships,
    source: :user

  validates :name,
    presence: true
end
