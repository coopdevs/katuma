class Group < ActiveRecord::Base
  resourcify

  has_one  :profile,
    as: :profilable
  has_many :users_units,
    dependent: :destroy
  has_many :users,
    through: :users_units
  has_many :waiting_list_memberships,
    dependent: :destroy
  has_many :waiting_users,
    through: :waiting_list_memberships,
    source: :user

  validates :name,
    presence: true
end
