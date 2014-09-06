# spec/lib/group_creation_spec.rb
require 'spec_helper'

describe GroupCreation do
  let(:creator) { FactoryGirl.build(:user) }
  let(:group) { FactoryGirl.build(:group) }
  let(:gc) { GroupCreation.new(group, creator) }

  describe 'initialize group and creator instance variables' do

    it 'initialize group instance variable' do
      expect(gc.group).to be group
    end

    it 'initialize creator instance variable' do
      expect(gc.creator).to be creator
    end
  end

  describe '#create' do

    it 'uses an ActiveRecord transaction' do
      expect(Group).to receive(:transaction)

      gc.create
    end

    it 'creates a new group' do
      expect(group).to receive(:save)

      gc.create
    end

    it 'adds creator as a group admin' do
      gc.create

      expect(group.admins).to include creator
    end
  end
end
