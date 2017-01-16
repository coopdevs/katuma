require 'rails_helper'
require 'ice_cube'

module Suppliers
  describe OrdersFrequency do
    let(:group) { FactoryGirl.create(:group) }
    let(:schedule) do
      IceCube::Schedule.new do |schedule|
        schedule.add_recurrence_rule(IceCube::Rule.weekly)
      end
    end

    describe 'Validations' do
      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:frequency) }
      it { is_expected.to validate_presence_of(:frequency_type) }

      it do
        is_expected.to validate_inclusion_of(:frequency_type)
          .in_array(Suppliers::FrequencyType::TYPES.values)
      end

      describe 'validates uniqueness of `frequency_type` scoped to `group_id`' do
        subject do
          FactoryGirl.create(
            :orders_frequency,
            :confirmation,
            group_id: group.id,
            ical: schedule.to_ical
          )
        end

        it do
          is_expected.to validate_uniqueness_of(:frequency_type).scoped_to(:group_id)
        end
      end

      describe 'passing no `ical` attribute' do
        subject do
          FactoryGirl.build(:orders_frequency, :confirmation, group_id: group.id)
        end

        it { is_expected.not_to be_valid }
      end
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:group) }
    end

    describe 'serialization' do
      it do
        is_expected.to serialize(:frequency)
          .as(IceCube::Schedule)
      end
    end

    describe '#to_ical' do
      subject { orders_frequency.to_ical }

      let(:orders_frequency) do
        FactoryGirl.create(
          :orders_frequency,
          :confirmation,
          group_id: group.id,
          ical: schedule.to_ical
        )
      end

      it { is_expected.to eq(schedule.to_ical) }
    end

    describe '#ical=' do
      let(:orders_frequency) do
        FactoryGirl.build(:orders_frequency, :confirmation, group_id: group.id)
      end

      context 'when providing a valid ical string' do
        let(:ical_string) { "DTSTART;TZID=CET:20161221T224133\nRRULE:FREQ=WEEKLY" }

        it 'changes the frequency' do
          orders_frequency.ical = ical_string
          expect(orders_frequency.frequency).to be_a(IceCube::Schedule)
        end

        it 'calls .from_ical on IceCube::Schedule' do
          expect(IceCube::Schedule).to receive(:from_ical).with(ical_string)
          orders_frequency.ical = ical_string
        end
      end

      context 'when providing an empty string' do
        subject { orders_frequency }
        before { orders_frequency.ical = '' }

        it { is_expected.not_to be_valid }
      end

      context 'when providing a nil value' do
        subject { orders_frequency }
        before { orders_frequency.ical = nil }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
