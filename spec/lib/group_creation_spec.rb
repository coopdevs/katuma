# spec/lib/group_creation_spec.rb
require 'spec_helper'

describe GroupCreation do
  let(:creator) { User.new }
  let(:group) { Group.new }
  let(:gc) { GroupCreation.new(group, creator) }

  it "must be initialized with a Group and a User" do
    expect { GroupCreation.new() }.to raise_error(ArgumentError)
  end

  describe "initialize group and creator instance variables" do
    it "initialize group instance variable" do
      expect(gc.group).to be group
    end

    it "initialize creator instance variable" do
      expect(gc.creator).to be creator
    end
  end

  describe "#create" do
    let(:creator) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.build(:group) }
    let(:gc) { GroupCreation.new(group, creator) }

    it "uses an ActiveRecord transaction" do
      expect(Group).to receive(:transaction)
      gc.create
    end

    it "saves a new group" do
      expect(group).to receive(:save)
      gc.create
    end

    xit "adds creator as a group admin" do
      allow(self).to receive(:add_creator_in_users_unit).and_return(true)
      expect(self).to receive(:add_creator_as_group_admin).and_return(true)
      gc.create
    end

    xit "adds creator in recently created UsersUnit" do
      allow(self).to receive(:add_creator_as_group_admin).and_return(true)
      expect(self).to receive(:add_creator_in_users_unit).and_return(true)
      gc.create
    end
  end

  describe "#add_creator_as_group_admin" do
    it "add admin role for group to creator" do
      expect(creator).to receive(:add_role).with(:admin, group).and_return(true)
      gc.add_creator_as_group_admin
    end
  end

  describe "#add_creator_in_users_unit" do
    xit "add creator to recently created UsersUnit" do
      expect(group).to receive(:users_units)
      gc.add_creator_in_users_unit
    end
  end

end
