module Onboarding
  class Invitation < ActiveRecord::Base

    self.table_name = :invitations

    belongs_to :invited_by, class_name: 'Account::User'
    belongs_to :invited_user, class_name: 'Account::User'
    belongs_to :group

    validates :group, :invited_by,
      presence: true
    validates :invited_user,
      presence: true,
      uniqueness: { scope: :group_id }
  end
end
