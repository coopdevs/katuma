module BasicResources
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    ROLES = { admin: 1, member: 2 }.freeze

    belongs_to :basic_resource_group,
      class_name: 'BasicResources::Group'.freeze,
      foreign_key: :basic_resource_group_id
    belongs_to :basic_resource_producer,
      class_name: 'BasicResources::Producer'.freeze,
      foreign_key: :basic_resource_producer_id
    belongs_to :user,
      class_name: 'BasicResources::User'.freeze
    belongs_to :group,
      class_name: 'BasicResources::Group'.freeze

    validates :role, presence: true
    validates :role, inclusion: { in: ROLES.values }

    validate :actor_presence
    validate :basic_resource_presence

    private

    # Validates `user_id` xor `group_id` presence
    #
    def actor_presence
      return if user_id.blank? ^ group_id.blank?

      errors.add(:base, 'Specify a `group_id` or `user_id`, but not both.')
    end

    # Validates `basic_resource_producer_id` xor `basic_resource_group_id` presence
    #
    def basic_resource_presence
      return if basic_resource_producer_id.blank? ^ basic_resource_group_id.blank?

      errors.add(
        :base, 'Specify a `basic_resource_group_id` or `basic_resource_producer_id`, but not both.'
      )
    end
  end
end
