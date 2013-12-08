# spec/models/customer_spec.rb
require 'spec_helper'

describe Group do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:group)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:users_units) }
  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_many(:users_units).dependent(:destroy) }
    it { should have_many(:users).through(:users_units) }
    it { should have_many(:waiting_list_memberships).dependent(:destroy) }
    it { should have_many(:waiting_users).through(:waiting_list_memberships) }
    it { should accept_nested_attributes_for :users_units }
  end

end
