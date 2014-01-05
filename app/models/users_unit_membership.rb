class UsersUnitMembership < ActiveRecord::Base
  belongs_to :users_unit
  belongs_to :user

  validates :users_unit, :user,
    presence: true
  validates :user_id,
    uniqueness: { scope: :users_unit_id }
  validate :is_waiting_user?

  # Check if a User is already member
  # of Group through a WaitingListMembership
  def is_waiting_user?
    if users_unit.group.waiting_users.include? user
      errors.add(:user_id, "User is already a member")
    end
  end
end
