class UsersUnit < ActiveRecord::Base
  belongs_to :group
  has_many :users_unit_memberships,
    dependent: :destroy
  has_many :users,
    through: :users_unit_memberships

  validates :name, :group,
    presence: true

  accepts_nested_attributes_for :users
end
