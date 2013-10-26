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
    it { should have_many(:members) }
    it { should have_many(:petitions) }
  end

  describe "member_list" do
    before :each do
      @user = FactoryGirl.create(:user)
      @supplier = FactoryGirl.create(:supplier)
      FactoryGirl.create(:membership,
                         :member => @user,
                         :memberable => @supplier)
    end

    it "returns array of members" do
      expect(@supplier.member_list).to eq([@user])
    end
  end
end
