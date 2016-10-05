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
      let(:group) do
        g = FactoryGirl.create(:group)
        Group.find(g.id)
      end
      let!(:supplier) { Supplier.create(group: group, producer: producer) }

      context 'when the user pertains to a group associated to the producer' do
        let(:group_user) { ::BasicResources::User.find(user.id) }
        let!(:membership) do
          ::BasicResources::Membership.create(
            basic_resource_group_id: group.id,
            user: group_user,
            role: Membership::ROLES[:member]
          )
        end

        context 'as `admin`' do
          let(:role) { Membership::ROLES[:admin] }

          it 'grants access' do
            expect(subject).to permit(user, producer)
          end
        end

        context 'as `member`' do
          let(:role) { Membership::ROLES[:member] }

          it 'grants access' do
            expect(subject).to permit(user, producer)
          end
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
