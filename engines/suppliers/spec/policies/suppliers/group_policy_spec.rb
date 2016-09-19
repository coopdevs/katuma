require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe GroupPolicy do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:group) { FactoryGirl.create(:group) }

    subject { described_class }

    permissions :update? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :create?, :destroy? do
      context 'when the user is member of the group' do
        let(:group_user) { ::Group::User.find(user.id) }
        before do
          ::Group::Membership.create(
            group: group,
            user: group_user,
            role: Membership::ROLES[:member]
          )
        end

        it 'denies access' do
          expect(subject).to_not permit(user, group)
        end
      end

      context 'when the user is admin of the group' do
        let(:group_user) { ::Group::User.find(user.id) }
        before do
          ::Group::Membership.create(
            group: group,
            user: group_user,
            role: Membership::ROLES[:admin]
          )
        end

        it 'grants access' do
          expect(subject).to permit(user, group)
        end
      end
    end

    permissions :show? do
      context 'when the user is member of the group' do
        let(:group_user) { ::Group::User.find(user.id) }
        before do
          ::Group::Membership.create(
            group: group,
            user: group_user,
            role: Membership::ROLES[:member]
          )
        end

        it 'grants access' do
          expect(subject).to permit(user, group)
        end
      end

      context 'when the user is admin of the group' do
        let(:group_user) { ::Group::User.find(user.id) }
        before do
          ::Group::Membership.create(
            group: group,
            user: group_user,
            role: Membership::ROLES[:admin]
          )
        end

        it 'grants access' do
          expect(subject).to permit(user, group)
        end
      end
    end
  end
end
