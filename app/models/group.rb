class Group < ActiveRecord::Base
  resourcify

  has_one  :profile,
    as: :profilable
  has_many :users_units,
    inverse_of: :group,
    dependent: :destroy
  has_many :users,
    through: :users_units

  validates :name,
    presence: true
  validates :users_units,
    presence: true

  accepts_nested_attributes_for :users_units
end
