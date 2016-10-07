require 'rails_helper'

module Suppliers
  describe ProducersCollection do
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
    let!(:test_producer_for_group) do
      producer = FactoryGirl.build(:producer, name: 'Related to group but test')
      ::BasicResources::ProducerCreator.new(
        producer: producer,
        creator: group_admin,
        group: group
      ).create!
      Producer.find(producer.id)
    end
    let(:producer_admin) do
      user = FactoryGirl.create(:user)
      ::BasicResources::User.find(user.id)
    end
    let!(:producer_for_user) do
      producer = FactoryGirl.build(:producer, name: 'Related to user')
      ::BasicResources::ProducerCreator.new(
        producer: producer,
        creator: producer_admin
      ).create!
      Producer.find(producer.id)
    end

    before do
      FactoryGirl.create(
        :supplier,
        group_id: group.id,
        producer_id: producer_for_group.id
      )
      FactoryGirl.create(
        :supplier,
        group_id: group.id,
        producer_id: producer_for_user.id
      )
    end

    describe '#build' do
      context 'when `group` is `nil`' do
        subject { described_class.new(user: user, group: nil).build }

        context 'when the user is `admin` of some producer' do
          let(:user) { User.find(producer_admin.id) }

          it { is_expected.to contain_exactly(producer_for_user) }
        end

        context 'when the user is not `admin` of any producer' do
          let(:user) { User.find(group_admin.id) }

          it { is_expected.to be_empty }
        end
      end

      context 'when `group` is not `nil`' do
        let(:suppliers_group) { Group.find(group.id) }

        subject { described_class.new(user: user, group: suppliers_group).build }

        context 'when the user does not pertain to the group' do
          let(:user) { User.find(producer_admin.id) }

          it { is_expected.to be_empty }
        end

        context 'when the user pertains to the group' do
          let(:user) { User.find(group_admin.id) }

          it do
            is_expected.to contain_exactly(
              Producer.find(producer_for_user.id),
              Producer.find(producer_for_group.id),
              Producer.find(test_producer_for_group.id)
            )
          end
        end
      end
    end
  end
end
