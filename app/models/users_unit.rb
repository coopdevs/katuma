class UsersUnit < ActiveRecord::Base
  belongs_to :group,
    inverse_of: :users_units
  has_many :users_unit_memberships,
    dependent: :destroy
  has_many :users,
    through: :users_unit_memberships,
    inverse_of: :users_unit

  validates :name, :group,
    presence: true

  accepts_nested_attributes_for :users
end
