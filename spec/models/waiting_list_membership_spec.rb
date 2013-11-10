require 'spec_helper'

describe WaitingListMembership do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:waiting_list_membership)).to be_valid
    end

    context "shoulda matchers" do
      before :each do
        WaitingListMembership.any_instance.stub(:is_in_users_unit?).and_return(true)
      end

      it { should validate_presence_of(:group) }
      it { should validate_presence_of(:user) }
      it {
        FactoryGirl.create :waiting_list_membership
        should validate_uniqueness_of(:user_id).scoped_to(:group_id)
      }
    end

    context "given a Group and a User" do
      before :each do
        @group = FactoryGirl.create(:group)
        @user = FactoryGirl.create(:user)
      end

      it "validates that User is not in users unit" do
        users_unit = FactoryGirl.create(:users_unit, group: @group)
        users_unit.users << @user

        expect {
          @group.waiting_users << @user
        }.to raise_exception(ActiveRecord::RecordInvalid)
      end

      it "validates that User is not subscribed twice" do
        @group.waiting_users << @user

        expect {
          @group.waiting_users << @user
        }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "Associations" do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
  end

end
