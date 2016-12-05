require 'rails_helper'

module Suppliers
  describe ProductsCollection do
    let(:group_admin) do
      user = FactoryGirl.create(:user)
      ::BasicResources::User.find(user.id)
    end
    let(:group) { FactoryGirl.create(:group) }
    let!(:group_membership) do
      FactoryGirl.create(
        :membership,
        basic_resource_group_id: group.id,
        user: group_admin,
        role: Membership::ROLES[:admin]
      )
    end
    let!(:producer_for_group) do
      producer = FactoryGirl.build(:producer, name: 'Related to group')
      ::BasicResources::ProducerCreator.new(
        producer: producer,
        creator: group_admin,
        group: group
      ).create!
      Producer.find(producer.id)
    end
    let!(:supplier) do
      FactoryGirl.create(
        :supplier,
        group_id: group.id,
        producer_id: producer_for_group.id
      )
    end
    let!(:pera) do
      FactoryGirl.create(
        :product,
        name: 'Pera',
        price: 1.99,
        unit: 0,
        producer_id: producer_for_group.id
      )
    end

    describe '#relation' do
      context 'when `group` is `nil`' do
        it 'raises a `GroupNotPresent` error' do
          expect do
            described_class.new(group: nil).relation
          end.to raise_error ProductsCollection::GroupNotPresent
        end
      end

      context 'when `group` is not `nil`' do
        let(:suppliers_group) { Group.find(group.id) }

        subject { described_class.new(group: suppliers_group).relation }

        context 'when the supplier is still active' do
          it do
            is_expected.to contain_exactly(
              Product.find(pera.id)
            )
          end
        end

        context 'when the supplier is not active anymore' do
          before { supplier.destroy }

          it do
            is_expected.to contain_exactly(
              Product.find(pera.id)
            )
          end
        end
      end

      context 'when `producer` is not `nil`' do
        subject { described_class.new(producer: producer_for_group).relation }

        it do
          is_expected.to contain_exactly(
            Product.find(pera.id)
          )
        end
      end
    end
  end
end
