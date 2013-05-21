# spec/models/customer_spec.rb
require 'spec_helper'

describe Customer do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:customer)).to be_valid
    end
    it { should validate_presence_of(:name) }
  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_many(:orders) }
    it { should have_many(:memberships) }
  end

  describe "members" do
    before :each do
      @user = FactoryGirl.create(:user)
      @customer = FactoryGirl.create(:customer)
      FactoryGirl.create(:membership,
                         :user => @user,
                         :memberable => @customer)
    end

    it "returns array of members" do
      expect(@customer.members).to eq([@user])
    end
  end
end
