require 'ice_cube'

module Suppliers
  class OrdersFrequency < ActiveRecord::Base
    self.table_name = :orders_frequencies

    serialize :frequency, IceCube::Schedule

    belongs_to :group

    validates :group, :frequency, :frequency_type, presence: true
    validates :frequency_type, inclusion: { in: FrequencyType::TYPES.values }
    validates :frequency_type, uniqueness: { scope: :group_id }

    delegate :to_ical, to: :frequency

    # TODO: Rename the delegation above to :ical and remove this reader; While
    # to_ical returns a valid ICAL string, this reader returns nil.
    attr_reader :ical
    deprecate :ical

    def ical=(value)
      self.frequency = to_frequency(value)
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
