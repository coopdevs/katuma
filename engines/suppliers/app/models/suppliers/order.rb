module Suppliers
  class Order < ActiveRecord::Base
    self.table_name = :orders

    has_many :order_lines, class_name: 'Suppliers::OrderLine'.freeze

    belongs_to :from_user, class_name: 'Suppliers::User'.freeze
    belongs_to :from_group, class_name: 'Suppliers::Group'.freeze
    belongs_to :to_group, class_name: 'Suppliers::Group'.freeze
    belongs_to :to_producer, class_name: 'Suppliers::Producer'.freeze

    validate :actor_presence
    validate :target_presence
    validates :confirm_before, presence: true

    private

    # Validates `from_user_id` xor `from_group_id` presence
    #
    def actor_presence
      return if from_user_id.blank? ^ from_group_id.blank?

      errors.add(:base, 'Specify a `from_group_id` or `from_user_id`, but not both.')
    end

    # Validates `to_group_id` xor `to_producer_id` presence
    #
    def target_presence
      return if to_group_id.blank? ^ to_producer_id.blank?

      errors.add(
        :base, 'Specify a `to_group_id` or `to_producer_id`, but not both.'
      )
    end
  end
end
