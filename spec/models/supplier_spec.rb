# spec/models/supplier_spec.rb
require 'spec_helper'

describe Supplier do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:supplier)).to be_valid
    end
    it { should validate_presence_of(:name) }
  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_many(:memberships) }
  end

  describe "members" do
    before :each do
      @user = FactoryGirl.create(:user)
      @supplier = FactoryGirl.create(:supplier)
      FactoryGirl.create(:membership,
                         :user => @user,
                         :memberable => @supplier)
    end

    it "returns array of members" do
      expect(@supplier.members).to eq([@user])
    end
  end
end
