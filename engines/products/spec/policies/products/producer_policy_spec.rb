require 'rails_helper'
require 'pundit/rspec'

module Products
  describe ProducerPolicy do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:group) { FactoryGirl.create(:group) }
    let(:producer) { FactoryGirl.create(:producer) }
    let(:group_user) { ::BasicResources::User.find(user.id) }

    subject { described_class }

    permissions :show?, :index? do
      context 'when the user is member of the producer' do
        before do
          ::BasicResources::Membership.create(
            basic_resource_producer_id: producer.id,
            user_id: user.id,
            role: Membership::ROLES[:member]
          )
        end

        it { is_expected.to permit(user, producer) }
      end

      context 'when the user is not member of the producer' do
        it { is_expected.not_to permit(user, producer) }

        context 'but the user is member of the producer\'s group' do
          before do
            ::BasicResources::Membership.create!(
              basic_resource_group_id: group.id,
              user_id: group_user.id,
              role: Membership::ROLES[:member]
            )
            ::BasicResources::Membership.create!(
              basic_resource_producer_id: producer.id,
              group: ::BasicResources::Group.find(group.id),
              role: Membership::ROLES[:admin]
            )
          end

          it { is_expected.to permit(user, producer) }
        end
      end
    end

    permissions :create?, :update?, :destroy? do
      context 'when the user is member of the producer' do
        before do
          ::BasicResources::Membership.create(
            basic_resource_producer_id: producer.id,
            user_id: user.id,
            role: Membership::ROLES[:member]
          )
        end

        it { is_expected.not_to permit(user, producer) }
      end

      context 'when the user is admin of the producer' do
        before do
          ::BasicResources::Membership.create(
            basic_resource_producer_id: producer.id,
            user_id: user.id,
            role: Membership::ROLES[:admin]
          )
        end

        it { is_expected.to permit(user, producer) }
      end

      context 'when the user is not admin nor member of the producer' do
        it { is_expected.not_to permit(user, producer) }

        context 'but the user is member of the producer\'s group' do
          before do
            ::BasicResources::Membership.create(
              basic_resource_group_id: group.id,
              user_id: group_user.id,
              role: Membership::ROLES[:member]
            )
            ::BasicResources::Membership.create(
              basic_resource_producer_id: producer.id,
              group: ::BasicResources::Group.find(group.id),
              role: Membership::ROLES[:member]
            )
          end

          it { is_expected.not_to permit(user, producer) }
        end

        context 'but the user is admin of the producer\'s group' do
          before do
            ::BasicResources::Membership.create!(
              basic_resource_group_id: group.id,
              user_id: group_user.id,
              role: Membership::ROLES[:admin]
            )
            ::BasicResources::Membership.create!(
              basic_resource_producer_id: producer.id,
              group: ::BasicResources::Group.find(group.id),
              role: Membership::ROLES[:admin]
            )
          end

          it { is_expected.to permit(user, producer) }
        end
      end
    end
  end
end
