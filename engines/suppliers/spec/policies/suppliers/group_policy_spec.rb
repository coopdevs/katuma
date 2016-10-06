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

    permissions :create?, :update?, :destroy? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end

    permissions :show?, :index? do
      context 'when the user is associated to the group' do
        let(:group_user) { ::BasicResources::User.find(user.id) }
        let!(:membership) do
          ::BasicResources::Membership.create(
            basic_resource_group_id: group.id,
            user_id: group_user.id,
            role: role
          )
        end

        context 'as `admin`' do
          let(:role) { Membership::ROLES[:admin] }

          it 'grants access' do
            expect(subject).to permit(user, group)
          end
        end

        context 'as `member`' do
          let(:role) { Membership::ROLES[:member] }

          it 'grants access' do
            expect(subject).to permit(user, group)
          end
        end
      end
    end
  end
end
