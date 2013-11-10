require 'spec_helper'

describe UsersUnitMembership do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:users_unit_membership)).to be_valid
    end

    context "shoulda matchers" do
      before :each do
        UsersUnitMembership.any_instance.stub(:is_waiting_user?).and_return(true)
      end

      it { should validate_presence_of(:users_unit) }
      it { should validate_presence_of(:user) }
      it {
        FactoryGirl.create :users_unit_membership
        should validate_uniqueness_of(:user_id).scoped_to(:users_unit_id)
      }
    end

    context "given a UsersUnit and a User" do
      before :each do
        @users_unit = FactoryGirl.create(:users_unit)
        @user = FactoryGirl.create(:user)
      end

      it "validates that User is not in waiting list" do
        @users_unit.group.waiting_users << @user

        expect {
          @users_unit.users << @user
        }.to raise_exception(ActiveRecord::RecordInvalid)
      end

      it "validates that User is not subscribed twice" do
        @users_unit.users << @user

        expect {
          @users_unit.users << @user
        }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "Associations" do
    it { should belong_to(:users_unit) }
    it { should belong_to(:user) }
  end

end
