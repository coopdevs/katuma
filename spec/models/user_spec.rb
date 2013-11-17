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
    it { should have_many(:api_keys).dependent(:destroy) }
  end

  it "create a valid session api key" do
    user = FactoryGirl.create :user
    api_key = user.session_api_key

    expect(api_key.access_token).to match /\S{32}/
    expect(api_key.user).to eq(user)
  end

end
