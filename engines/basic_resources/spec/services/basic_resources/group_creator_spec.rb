require 'rails_helper'

module BasicResources
  describe GroupCreator do
    let(:creator) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:group) { FactoryGirl.build(:group) }
    let(:gc) { described_class.new(group, creator) }

    describe 'initialize group and creator instance variables' do
      it 'initialize group instance variable' do
        expect(gc.group).to be group
      end

      it 'initialize creator instance variable' do
        expect(gc.creator).to be creator
      end
    end

    describe '#create' do
      it 'creates a new group' do
        expect(group).to receive(:save!)

        gc.create
      end

      it 'adds creator as a group admin' do
        gc.create

        is_admin = Membership.where(
          basic_resource_group_id: group.id,
          user: creator,
          role: ::BasicResources::Membership::ROLES[:admin]
        ).any?

        expect(is_admin).to be_truthy
      end
    end
  end
end
