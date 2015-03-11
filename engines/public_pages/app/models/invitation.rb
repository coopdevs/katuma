class Invitation < ActiveRecord::Base

  belongs_to :user, foreign_key: :invited_by
  belongs_to :group

  validates :group, :user,
    presence: true
  validates :email,
    presence: true,
    uniqueness: { scope: :group_id }
end
