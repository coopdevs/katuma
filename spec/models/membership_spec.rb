# spec/models/membership_spec.rb
require 'spec_helper'

describe Membership do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:membership)).to be_valid
    end
    it { should validate_presence_of(:memberable) }
    it { should validate_presence_of(:member) }
    # This pending is related to the following issue
    # https://github.com/thoughtbot/shoulda-matchers/issues/203
    xit { FactoryGirl.create(:membership)
         should validate_uniqueness_of(:member_id).scoped_to(:memberable_id, :memberable_type) }

    context "Custom validators" do

      context "A User is member of Customer through UsersUnit" do
        before :each do
          @user = FactoryGirl.create :user
          @coop = FactoryGirl.create :customer
          @unit = FactoryGirl.create :users_unit, customer: @coop
          @unit.users << @user
          @wait = FactoryGirl.create :waiting_list, customer: @coop
        end

        it "A User cannot be added to a WaitingList if he's already a Customer member" do
          expect {
            @wait.users << @user
          }.to raise_exception(ActiveRecord::RecordInvalid, /Member User is already a member/)
        end
      end

    end
  end

  describe "Associations" do
    it { should belong_to(:member) }
    it { should belong_to(:memberable) }
  end

  describe "Testing membership behaviours" do
    before :each do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @coope1 = FactoryGirl.create(:customer)
      @coope2 = FactoryGirl.create(:customer)
      @users_unit1 = FactoryGirl.create(:users_unit, name: "My new unit", customer: @coope1)
      @users_unit1.users << [@user1, @user2]
    end

    it "One user could pertain to many customers through different users_units" do
      @users_unit2 = FactoryGirl.create(:users_unit, name: "My other unit", customer: @coope2)
      @users_unit2.users << @user2

      expect(@coope2.users).to eq([@user2])
      expect(@user2.customers).to eq([@coope1, @coope2])
    end
  end

end
