require 'rails_helper'

module Suppliers
  describe OrdersFrequenciesSerializer do
    let(:schedule) do
      IceCube::Schedule.new { |f| f.add_recurrence_rule IceCube::Rule.weekly }
    end
    let(:orders_frequency) do
      instance_double(
        OrdersFrequency,
        id: 13,
        group_id: 666,
        to_ical: schedule.to_ical,
        frequency_type: FrequencyType::TYPES[:confirmation],
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end

    subject { described_class.new([orders_frequency]).to_hash }

    it do
      is_expected.to contain_exactly(
        match(
          id: orders_frequency.id,
          group_id: orders_frequency.group_id,
          to_ical: schedule.to_ical,
          frequency_type: orders_frequency.frequency_type,
          created_at: orders_frequency.created_at,
          updated_at: orders_frequency.updated_at
        )
      )
    end
  end
end
