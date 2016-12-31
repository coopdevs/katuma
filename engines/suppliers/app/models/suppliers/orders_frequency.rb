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

    # TODO: Rename the delegation above to :ical and remove this reader; While
    # to_ical returns a valid ICAL string, this reader returns nil.
    attr_reader :ical
    deprecate :ical

    def ical=(value)
      self.frequency = to_frequency(value)
    end

    private

    def to_frequency(value)
      if value.blank?
        nil
      else
        IceCube::Schedule.from_ical(value)
      end
    end
  end
end
