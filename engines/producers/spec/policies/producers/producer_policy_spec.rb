require 'rails_helper'
require 'pundit/rspec'

module Producers
  describe ProducerPolicy do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:producer) do
      FactoryGirl.create(:producer)
    end

    subject { described_class }

    permissions :show?, :index? do
      context 'when the user is member of the producer' do
        before do
          Membership.create(
            producer: producer,
            user: user,
            role: Membership::ROLES[:member]
          )
        end

        it 'grants access' do
          expect(subject).to permit(user, producer)
        end
      end

      context 'when the user is not member of the producer' do
        it 'denies access' do
          expect(subject).to_not permit(user, producer)
        end

        context 'but the user is member of the producer\'s group' do
          let(:group) { FactoryGirl.create(:group) }
          let(:group_user) { ::Group::User.find(user.id) }
          before do
            ::Group::Membership.create(
              group: group,
              user: group_user,
              role: Membership::ROLES[:member]
            )
            Membership.create(
              producer: producer,
              group: Group.find(group.id),
              role: Membership::ROLES[:admin]
            )
          end

          it 'grants access' do
            expect(subject).to permit(user, producer)
          end
        end
      end
    end

    permissions :create?, :update?, :destroy? do
      context 'when the user is member of the producer' do
        before do
          Membership.create(
            producer: producer,
            user: user,
            role: Membership::ROLES[:member]
          )
        end

        it 'denies access' do
          expect(subject).to_not permit(user, producer)
        end
      end

      context 'when the user is admin of the producer' do
        before do
          Membership.create(
            producer: producer,
            user: user,
            role: Membership::ROLES[:admin]
          )
        end

        it 'grants access' do
          expect(subject).to permit(user, producer)
        end
      end

      context 'when the user is not admin nor member of the producer' do
        it 'denies access' do
          expect(subject).to_not permit(user, producer)
        end

        context 'but the user is member of the producer\'s group' do
          let(:group) { FactoryGirl.create(:group) }
          let(:group_user) { ::Group::User.find(user.id) }
          before do
            ::Group::Membership.create(
              group: group,
              user: group_user,
              role: Membership::ROLES[:member]
            )
            Membership.create(
              producer: producer,
              group: Group.find(group.id),
              role: Membership::ROLES[:member]
            )
          end

          it 'denies access' do
            expect(subject).to_not permit(user, producer)
          end
        end

        context 'but the user is admin of the producer\'s group' do
          let(:group) { FactoryGirl.create(:group) }
          let(:group_user) { ::Group::User.find(user.id) }
          before do
            ::Group::Membership.create(
              group: group,
              user: group_user,
              role: Membership::ROLES[:admin]
            )
            Membership.create(
              producer: producer,
              group: Group.find(group.id),
              role: Membership::ROLES[:admin]
            )
          end

          it 'grants access' do
            expect(subject).to permit(user, producer)
          end
        end
      end
    end
  end
end
