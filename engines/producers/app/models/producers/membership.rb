module Producers
  class Membership < ActiveRecord::Base

    self.table_name = :producers_memberships

    ROLES = { admin: 1, member: 2 }.freeze

    belongs_to :producer, class_name: 'Producers::Producer'.freeze
    belongs_to :user, class_name: 'Producers::User'.freeze
    belongs_to :group, class_name: 'Producers::Group'.freeze

    validates :producer, :role, presence: true
    validates :role, inclusion: { in: ROLES.values }
    validate :user_or_group_presence

    private

    # Validates `user_id` xor `group_id` presence
    #
    def user_or_group_presence
      return if user.blank? ^ group.blank?

      errors.add(:base, 'Specify a `group_id` or `user_id`, but not both.')
    end
  end
end
