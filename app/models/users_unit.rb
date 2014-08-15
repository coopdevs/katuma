class UsersUnit < ActiveRecord::Base

  belongs_to :group
  has_many :users_unit_memberships,
    dependent: :destroy
  has_many :users,
    through: :users_unit_memberships
  has_many :admins,
    -> { where "users_unit_memberships.role = #{ UsersUnitMembership::ROLES[:admin] }" },
    through: :users_unit_memberships,
    source: :user

  validates :name, :group,
    presence: true
end
