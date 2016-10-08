require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe ProducerPolicy do
    subject { described_class }

    permissions :update?, :destroy? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end

    # You don't need permissions at Producer level to
    # add a Producer as a Supplier to a Group, for now...
    #
    permissions :create? do
      it 'grants access in any case' do
        expect(subject).to permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :show? do
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
      end
      let!(:test_producer_for_group) do
        producer = FactoryGirl.build(:producer, name: 'Related to group but test')
        ::BasicResources::ProducerCreator.new(
          producer: producer,
          creator: group_admin,
          group: group
        ).create!
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
      end

      context 'when the user is member of the producer directly' do
        it 'grants access' do
          expect(subject).to permit(producer_admin, producer_for_user)
        end
      end

      context 'when the user is member of the producer through a group' do
        it 'grants access' do
          expect(subject).to permit(group_admin, producer_for_group)
        end
      end

      context 'when the user is member of a group which the producer is provider' do
        before do
          FactoryGirl.create(
            :supplier,
            group_id: group.id,
            producer_id: producer_for_user.id
          )
        end

        it 'grants access' do
          expect(subject).to permit(group_admin, producer_for_user)
        end
      end

      context 'when the user is not related to the producer' do
        let(:other_user) do
          user = FactoryGirl.create(:user)
          User.find(user.id)
        end

        it 'denies access' do
          expect(subject).to_not permit(other_user, producer_for_group)
        end
      end
    end
  end
end
