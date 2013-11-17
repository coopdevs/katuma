# spec/models/user_spec.rb
require 'spec_helper'

describe User do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { FactoryGirl.create :user
         should validate_uniqueness_of(:email) }
  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_many(:waiting_list_memberships).dependent(:destroy) }
    it { should have_many(:users_unit_memberships).dependent(:destroy) }
    it { should have_many(:users_units).through(:users_unit_memberships) }
    it { should have_many(:groups).through(:users_units) }
    it { should have_many(:waiting_groups).through(:waiting_list_memberships) }
  end

end
