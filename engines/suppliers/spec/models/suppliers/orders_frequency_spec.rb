require 'rails_helper'
require 'ice_cube'

module Suppliers
  describe OrdersFrequency do
    let(:group) { FactoryGirl.create(:group) }
    let(:schedule) do
      IceCube::Schedule.new do |f|
        f.add_recurrence_rule IceCube::Rule.weekly
      end
    end

    describe 'Validations' do
      it 'has a valid factory' do
        expect(
          FactoryGirl.build(
            :orders_frequency,
            group_id: group.id,
            ical: schedule.to_ical,
            frequency_type: OrdersFrequency::FREQUENCY_TYPES[:confirmation]
          )
        ).to be_valid
      end

      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:frequency) }
      it { is_expected.to validate_presence_of(:frequency_type) }
      it do
        is_expected.to validate_inclusion_of(:frequency_type)
          .in_array(OrdersFrequency::FREQUENCY_TYPES.values)
      end
      describe 'validates uniqueness of `frequency_type` scoped to `group_id`' do
        before do
          FactoryGirl.create(
            :orders_frequency,
            group_id: group.id,
            ical: schedule.to_ical,
            frequency_type: OrdersFrequency::FREQUENCY_TYPES[:confirmation]
          )
        end

        it { is_expected.to validate_uniqueness_of(:frequency_type).scoped_to(:group_id) }
      end

      context 'passing no `ical` attribute' do
        let(:orders_frequency) do
          FactoryGirl.build(
            :orders_frequency,
            group_id: group.id,
            frequency_type: OrdersFrequency::FREQUENCY_TYPES[:confirmation]
          )
        end

        before { orders_frequency.valid? }

        subject { orders_frequency.errors.messages }

        it do
          is_expected.to match(
            ical: ['is invalid'],
            frequency: ["can't be blank"]
          )
        end
      end
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:group) }
    end

    describe '#to_ical' do
      let(:orders_frequency) do
        FactoryGirl.create(
          :orders_frequency,
          group_id: group.id,
          ical: schedule.to_ical,
          frequency_type: OrdersFrequency::FREQUENCY_TYPES[:confirmation]
        )
      end

      subject { orders_frequency.to_ical }

      it { is_expected.to eq(orders_frequency.frequency.to_ical) }

      context 'passing an `ical` attribute' do
        let(:orders_frequency) do
          FactoryGirl.create(
            :orders_frequency,
            group_id: group.id,
            ical: schedule.to_ical,
            frequency_type: OrdersFrequency::FREQUENCY_TYPES[:confirmation]
          )
        end

        it { is_expected.to eq(schedule.to_ical) }
      end
    end
  end
end
