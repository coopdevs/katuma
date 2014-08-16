require 'spec_helper'

describe GroupPolicy do

  subject { GroupPolicy.new(user, group) }

  let(:group) { FactoryGirl.create :group }
  let(:user) { FactoryGirl.create :user }

  context 'A user that does not pertain to the group' do

    it { should     permit :create }
    it { should_not permit :show }
    it { should_not permit :update }
    it { should_not permit :destroy }
  end

  context 'A group admin' do

    before do
      FactoryGirl.create(:membership, user: user, group: group, role: Membership::ROLES[:admin])
    end

    it { should permit :create }
    it { should permit :show }
    it { should permit :update }
    it { should permit :destroy }
  end
end
