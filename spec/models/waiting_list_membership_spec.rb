require 'spec_helper'

describe WaitingListMembership do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:waiting_list_membership)).to be_valid
    end
    it {
      WaitingListMembership.any_instance.stub(:is_in_users_unit?).and_return(true)
      should validate_presence_of(:group)
    }
    it {
      WaitingListMembership.any_instance.stub(:is_in_users_unit?).and_return(true)
      should validate_presence_of(:user)
    }
    it "validates that User is not in users unit" do
      group = FactoryGirl.create(:group)
      users_unit = FactoryGirl.create(:users_unit, group: group)
      user = FactoryGirl.create(:user)
      users_unit.users << user

      expect {
        group.waiters << user
      }.to raise_exception(ActiveRecord::RecordInvalid)
    end

  end

  describe "Associations" do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
  end

end
