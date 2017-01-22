require 'ice_cube'

module Suppliers
  class OrdersFrequency < ActiveRecord::Base
    self.table_name = :orders_frequencies

    serialize :frequency, IceCube::Schedule

    belongs_to :group

    validates :group, :frequency, :frequency_type, presence: true
    validates :frequency_type, inclusion: { in: FrequencyType::TYPES.values }
    validates :frequency_type, uniqueness: { scope: :group_id }

    def ical=(value)
      self.frequency = to_frequency(value)
    end

    def ical
      frequency.to_ical
    end

    private

    # Returns the passed ical frequency value as an IceCube Schedule instance
    #
    # @return [Maybe<IceCube::Schedule>]
    def to_frequency(value)
      IceCube::Schedule.from_ical(value) if value.present?
    end
  end
end
