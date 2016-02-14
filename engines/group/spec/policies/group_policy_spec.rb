require 'rails_helper'
require_relative '../../../../spec/support/matchers/pundit_matchers.rb'

describe Group::GroupPolicy do

  let(:group) { FactoryGirl.create :group }
  let(:user) { FactoryGirl.create :user }

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
