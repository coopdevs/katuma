class User < ActiveRecord::Base
  rolify
  has_secure_password

  has_one  :profile,
    as: :profilable
  has_many :waiting_list_memberships,
    dependent: :destroy
  has_many :users_unit_memberships,
    dependent: :destroy
  has_many :users_units,
    through: :users_unit_memberships
  has_many :groups,
    through: :users_units
  has_many :waiting_groups,
    through: :waiting_list_memberships,
    source: :group

  validates :name,
    presence: true
  validates :email,
    presence: true,
    uniqueness: true
end
