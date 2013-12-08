class Group < ActiveRecord::Base
  resourcify

  has_one  :profile,
    as: :profilable
  has_many :users_units,
    inverse_of: :group,
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

  accepts_nested_attributes_for :users_units
end
