require 'spec_helper'

describe GroupPolicy do
  subject { GroupPolicy.new(user, group) }

  let(:group) { FactoryGirl.create :group }

  context 'A new user' do
    let(:user) { FactoryGirl.create :user }

    it { should     permit :create }
    it { should_not permit :show }
    it { should_not permit :update }
    it { should_not permit :destroy }
  end

  context 'A group admin' do
    let(:user) { FactoryGirl.create :user }
    let(:group) { FactoryGirl.create :group }
    before :each do
      user.add_role :admin, group
    end

    it { should permit :create }
    it { should permit :show }
    it { should permit :update }
    it { should permit :destroy }
  end
end
