require 'spec_helper'

describe UsersUnit do

  describe "Validations" do
    it "should have valid factory" do
      expect(FactoryGirl.build(:users_unit)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:customer) }
    it { FactoryGirl.create :users_unit
         should validate_uniqueness_of(:customer_id) }
  end

  describe "Associations" do
    it { should belong_to(:customer) }
    it { should have_db_index(:customer_id) }
    it { should have_many(:memberships) }
    it { should have_many(:users).through(:memberships) }
  end

end
