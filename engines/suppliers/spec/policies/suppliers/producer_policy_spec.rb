require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe ProducerPolicy do
    subject { described_class }

    permissions :create? do
      it 'is set to `true` by default' do
        expect(subject).to permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :update?, :destroy? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :show? do
      let(:user) do
        user = FactoryGirl.create(:user)
        User.find(user.id)
      end
      let(:producer) do
        producer = FactoryGirl.create(:producer)
        Producer.find(producer.id)
      end

      context 'when the user pertains to a group associated to the producer' do
        let(:group) { FactoryGirl.create(:group) }
        let(:group_user) { ::Group::User.find(user.id) }
        let(:supplier_group) { ::Suppliers::Group.find(group.id) }

        before do
          ::Group::Membership.create(
            group: group,
            user: group_user,
            role: Membership::ROLES[:member]
          )
          Supplier.create(group: supplier_group, producer: producer)
        end

        it 'grants access' do
          expect(subject).to permit(user, producer)
        end
      end

      context 'when the user does not pertain to a group associated to the producer' do
        it 'denies access' do
          expect(subject).to_not permit(user, producer)
        end
      end
    end
  end
end
