require 'rails_helper'
require_relative '../../../../../spec/support/matchers/pundit_matchers.rb'

module BasicResources
  describe GroupPolicy do
    let(:group) { FactoryGirl.create :group }
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end

    subject { GroupPolicy.new(user, group) }

    context 'When the user does not pertain to the group' do
      it { is_expected.to permit_to :create }
      it { is_expected.to_not permit_to :show }
      it { is_expected.to_not permit_to :update }
      it { is_expected.to_not permit_to :destroy }
    end

    context 'When the user pertains to the group' do
      let!(:membership) do
        FactoryGirl.create(
          :membership,
          user: user,
          basic_resource_group_id: group.id,
          role: role
        )
      end

      context 'as a group admin' do
        let(:role) { Membership::ROLES[:admin] }

        it { is_expected.to permit_to :create }
        it { is_expected.to permit_to :show }
        it { is_expected.to permit_to :update }
        it { is_expected.to permit_to :destroy }
      end

      context 'A group member' do
        let(:role) { Membership::ROLES[:member] }

        it { is_expected.to permit_to :create }
        it { is_expected.to permit_to :show }
        it { is_expected.to_not permit_to :update }
        it { is_expected.to_not permit_to :destroy }
      end
    end
  end
end
