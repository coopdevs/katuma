require 'rails_helper'

module Suppliers
  module OrdersCollection
    describe ToProducer do
      let(:producer_admin) do
        user = FactoryGirl.create(:user)
        ::BasicResources::User.find(user.id)
      end
      let(:group_admin) { FactoryGirl.create(:user) }
      let(:group_member) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }
      let(:other_group) { FactoryGirl.create(:group) }
      let!(:admin_group_membership) do
        FactoryGirl.create(
          :membership,
          basic_resource_group_id: group.id,
          user_id: group_admin.id,
          role: Membership::ROLES[:admin]
        )
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
          producer_id: producer_for_user.id
        )
        FactoryGirl.create(
          :supplier,
          group_id: other_group.id,
          producer_id: producer_for_user.id
        )
      end

      describe '#relation' do
        let!(:first_order) do
          FactoryGirl.create(
            :order,
            from_group_id: group.id,
            to_producer_id: producer_for_user.id
          )
        end
        let!(:second_order) do
          FactoryGirl.create(
            :order,
            from_group_id: group.id,
            to_producer_id: producer_for_user.id,
            confirm_before: Time.at(1318996912).utc.to_datetime
          )
        end
        let!(:other_order) do
          FactoryGirl.create(
            :order,
            from_group_id: other_group.id,
            to_producer_id: producer_for_user.id
          )
        end

        subject do
          described_class.new(user: group_admin, params: params).relation
        end

        context 'passing no parameters' do
          let(:params) { {} }
          it { is_expected.to contain_exactly(first_order, second_order, other_order) }
        end

        context 'passing `from_group_id` parameter' do
          let(:params) { { from_group_id: group.id } }
          it { is_expected.to contain_exactly(first_order, second_order) }
        end

        context 'passing `to_producer_id` parameter' do
          let(:params) { { to_producer_id: producer_for_user.id } }

          it do
            is_expected.to contain_exactly(first_order, second_order, other_order)
          end
        end

        context 'passing `confirm_before` parameter' do
          let(:params) do
            { confirm_before: Time.at(1318996912).utc.to_datetime }
          end

          it { is_expected.to contain_exactly(second_order) }
        end
      end
    end
  end
end
