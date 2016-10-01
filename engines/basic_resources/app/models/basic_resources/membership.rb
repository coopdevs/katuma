module BasicResources
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    ROLES = { admin: 1, member: 2 }.freeze

    belongs_to :user, class_name: 'BasicResources::User'.freeze
    belongs_to :group, class_name: 'BasicResources::User'.freeze

    validates :role, presence: true
    validates :role, inclusion: { in: ROLES.values }

    validate :user_or_group_presence

    private

    # Validates `user_id` xor `group_id` presence
    #
    def user_or_group_presence
      return if user_id.blank? ^ group_id.blank?

      errors.add(:base, 'Specify a `group_id` or `user_id`, but not both.')
    end
  end
end
