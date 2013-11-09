class UsersUnitMembership < ActiveRecord::Base
  belongs_to :users_unit
  belongs_to :user

  validates  :users_unit, :user,
    presence: true
  validate :is_waiter?

  # Check if a User is already member
  # of Customer through a WaitingListMembership
  def is_waiter?
    if users_unit.group.waiters.include? user
      errors.add(:user_id, "User is already a member")
    end
  end
end
