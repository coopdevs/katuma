class Membership < ActiveRecord::Base
  belongs_to :member, :polymorphic => true
  belongs_to :memberable, :polymorphic => true

  validates :member, :memberable,
              presence: true
  validates :member_id,
    uniqueness: {
      scope: [:memberable_id, :memberable_type]
    }
  validate :member_in_users_unit?, if: "memberable_type == 'WaitingList'"

  # Check if a User is already member
  # of a Customer through a UsersUnit
  def member_in_users_unit?
    if memberable.customer.users.include? member
      errors.add(:member_id, "User is already a member")
    end
  end
end
