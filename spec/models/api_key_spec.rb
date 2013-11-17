require 'spec_helper'

describe ApiKey do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:api_key)).to be_valid
    end
    it { should validate_presence_of(:access_token) }
    it { should validate_presence_of(:user) }
    it { FactoryGirl.create :api_key
         should validate_uniqueness_of(:access_token) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end

  pending "generates access token after initialization" do
  end
end
