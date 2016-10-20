require 'ice_cube'

module Suppliers
  class OrdersFrequency < ActiveRecord::Base
    self.table_name = :orders_frequencies

    FREQUENCY_TYPES = { confirmation: 0, delivery: 1 }.freeze

    serialize :frequency, IceCube::Schedule

    belongs_to :group

    validates :group, :frequency, :frequency_type, presence: true
    validates :frequency_type, inclusion: { in: FREQUENCY_TYPES.values }
    validates :frequency_type, uniqueness: { scope: :group_id }

    delegate :to_ical, to: :frequency

    attr_accessor :ical

    # TODO: better callback
    #
    # We can only store a `frequency` through `ical`
    before_validation do
      if ical.blank?
        errors.add(:ical)
      else
        self.frequency = IceCube::Schedule.from_ical(ical)
      end
    end
  end
end
