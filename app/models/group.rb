class Group < ActiveRecord::Base

  has_one  :profile,
    as: :profilable
  has_many :memberships,
    dependent: :destroy
  has_many :users,
    through: :memberships
  has_many :users_units

  validates :name,
    presence: true
end
