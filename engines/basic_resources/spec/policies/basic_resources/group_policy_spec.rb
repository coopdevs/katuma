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

    context 'A user that does not pertain to the group' do
      it { should     permit_to :create }
      it { should_not permit_to :show }
      it { should_not permit_to :update }
      it { should_not permit_to :destroy }
    end

    context 'A group admin' do
      before do
        FactoryGirl.create(:membership, user: user, group: group, role: Membership::ROLES[:admin])
      end

      it { should permit_to :create }
      it { should permit_to :show }
      it { should permit_to :update }
      it { should permit_to :destroy }
    end

    context 'A group member' do
      before do
        FactoryGirl.create(:membership, user: user, group: group, role: Membership::ROLES[:member])
      end

      it { should permit_to :create }
      it { should permit_to :show }
      it { should_not permit_to :update }
      it { should_not permit_to :destroy }
    end

    context 'A group waiter' do
      before do
        FactoryGirl.create(:membership, user: user, group: group, role: Membership::ROLES[:waiting])
      end

      it { should permit_to :create }
      it { should_not permit_to :show }
      it { should_not permit_to :update }
      it { should_not permit_to :destroy }
    end
  end
end