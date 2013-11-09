class WaitingListMembership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates  :group, :user,
    presence: true
  validate :is_in_users_unit?

  # Check if a User is already member
  # of Customer through a UsersUnit
  def is_in_users_unit?
    if group.users.include? user
      errors.add(:user_id, "User is already a member")
    end
  end
end
