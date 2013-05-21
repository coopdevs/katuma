# spec/models/membership_spec.rb
require 'spec_helper'

describe Membership do

  describe "Validations" do
    it "has valid factory" do
      expect(FactoryGirl.build(:membership)).to be_valid
    end
    it { should validate_presence_of(:memberable_id) }
    it { should validate_presence_of(:memberable_type) }
    it { should validate_presence_of(:user_id) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:memberable) }
  end

end
