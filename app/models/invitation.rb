class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  validates :group, :user,
    presence: true
  validates :email,
    presence: true,
    uniqueness: { scope: :group_id }
end
