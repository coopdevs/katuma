module Onboarding
  class Invitation < ActiveRecord::Base

    self.table_name = :invitations

    belongs_to :invited_by, class_name: 'Onboarding::User'
    belongs_to :group

    before_validation do |invitation|
      invitation.token ||= SecureRandom.urlsafe_base64(32)
    end

    validates :group, :invited_by, :email, presence: true
    validates :email, email: true
    validates :token, presence: true, uniqueness: true
  end
end
