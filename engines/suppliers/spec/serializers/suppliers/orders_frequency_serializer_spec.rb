require 'rails_helper'

module Suppliers
  describe OrdersFrequencySerializer do
    let(:group) { FactoryGirl.create(:group) }
    let(:schedule) do
      IceCube::Schedule.new { |f| f.add_recurrence_rule IceCube::Rule.weekly }
    end
    let(:orders_frequency) do
      FactoryGirl.create(
        :orders_frequency,
        group_id: group.id,
        ical: schedule.to_ical,
        frequency_type: FrequencyType::TYPES[:confirmation]
      )
    end

    subject { described_class.new(orders_frequency).to_hash }

    it do
      is_expected.to eq(
        id: orders_frequency.id,
        group_id: orders_frequency.group_id,
        to_ical: schedule.to_ical,
        frequency_type: orders_frequency.frequency_type,
        created_at: orders_frequency.created_at,
        updated_at: orders_frequency.updated_at
      )
    end
  end
end
