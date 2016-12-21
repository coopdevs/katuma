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
          .in_array(OrdersFrequency::FREQUENCY_TYPES.values)
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
  end
end
