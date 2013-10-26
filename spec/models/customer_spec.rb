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
    it { should have_many(:members) }
    it { should have_many(:memberables) }
    it { should have_many(:petitions) }
    it { should have_many(:customers).through(:members) }
    it { should have_many(:users_units).dependent(:destroy) }
    it { should have_many(:users).through(:users_units) }
  end

end
