require 'spec_helper'

describe UsersUnitMembership do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:users_unit_membership)).to be_valid
    end
    it {
      UsersUnitMembership.any_instance.stub(:is_waiter?).and_return(true)
      should validate_presence_of(:users_unit)
    }
    it {
      UsersUnitMembership.any_instance.stub(:is_waiter?).and_return(true)
      should validate_presence_of(:user)
    }
    it "validates that User is not in waiting list" do
      users_unit = FactoryGirl.create(:users_unit)
      user = FactoryGirl.create(:user)
      users_unit.group.waiters << user

      expect {
        users_unit.users << user
      }.to raise_exception(ActiveRecord::RecordInvalid)
    end

  end

  describe "Associations" do
    it { should belong_to(:users_unit) }
    it { should belong_to(:user) }
  end

end
