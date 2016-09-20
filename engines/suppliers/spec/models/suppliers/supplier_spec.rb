require 'rails_helper'

module Suppliers
  describe Supplier do
    let(:producer) do
      producer = FactoryGirl.create(:producer)
      Producer.find(producer.id)
    end
    let(:group) do
      group = FactoryGirl.create(:group)
      Group.find(group.id)
    end

    describe 'Validations' do
      it 'has a valid factory' do
        expect(
          FactoryGirl.build(
            :supplier,
            group: group,
            producer: producer
          )
        ).to be_valid
      end

      it { is_expected.to validate_presence_of(:producer) }
      it { is_expected.to validate_presence_of(:group) }
    end

    describe 'Associations' do
      it { should belong_to(:producer) }
      it { should belong_to(:group) }
    end
  end
end
