class Group < ActiveRecord::Base
  has_one  :profile,
    as: :profilable
  has_many :users_units,
    dependent: :destroy
  has_many :users,
    through: :users_units
  has_many :waiting_list_memberships,
    dependent: :destroy
  has_many :waiters,
    through: :waiting_list_memberships,
    source: :user

  validates :name, presence: true
end
