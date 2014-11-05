class User < ActiveRecord::Base

  has_secure_password

  has_one  :profile,
    as: :profilable
  has_many :memberships,
    dependent: :destroy
  has_many :groups,
    through: :memberships
  has_many :users_unit_memberships,
    dependent: :destroy
  has_many :users_units,
    through: :users_unit_memberships
  has_many :invitations,
    dependent: :destroy

  validates :name,
    presence: true
  validates :email,
    presence: true,
    uniqueness: true
end
