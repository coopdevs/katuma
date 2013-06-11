# spec/models/user_spec.rb
require 'spec_helper'

describe User do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    xit { should validate_uniqueness_of(:email) }
  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_many(:memberships) }
  end

end
