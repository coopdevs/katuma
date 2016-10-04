require 'rails_helper'
require 'pundit/rspec'

module BasicResources
  describe ProducerPolicy do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:producer) { FactoryGirl.create(:producer) }

    subject { described_class }

    permissions :create?, :show?, :index? do
      it 'denies access' do
        expect(subject).to_not permit(user, producer)
      end
    end

    permissions :update?, :destroy? do
      context 'when the user is associated to the producer' do
        let!(:membership) do
          Membership.create(
            basic_resource_producer_id: producer.id,
            user: user,
            role: role
          )
        end

        context 'as `member`' do
          let(:role) { Membership::ROLES[:member] }

          it 'denies access' do
            expect(subject).to_not permit(user, producer)
          end
        end

        context 'as `admin`' do
          let(:role) { Membership::ROLES[:admin] }

          it 'grants access' do
            expect(subject).to permit(user, producer)
          end
        end
      end

      context 'when the user is not associated to the producer' do
        it 'denies access' do
          expect(subject).to_not permit(user, producer)
        end
      end

      context 'when the provider is associated to a group' do
        let(:group) { FactoryGirl.create(:group) }

        before do
          Membership.create(
            basic_resource_producer_id: producer.id,
            group: group,
            role: Membership::ROLES[:admin]
          )
        end

        context 'and the user is associated to the group' do
          let!(:group_membership) do
            Membership.create(
              basic_resource_group_id: group.id,
              user: user,
              role: role
            )
          end

          context 'as a group `admin`' do
            let(:role) { Membership::ROLES[:admin] }

            it 'grants access' do
              expect(subject).to permit(user, producer)
            end
          end

          context 'as a group `member`' do
            let(:role) { Membership::ROLES[:member] }

            it 'denies access' do
              expect(subject).to_not permit(user, producer)
            end
          end
        end

        context 'and the user is associated to the group' do
          it 'denies access' do
            expect(subject).to_not permit(user, producer)
          end
        end
      end
    end
  end
end
