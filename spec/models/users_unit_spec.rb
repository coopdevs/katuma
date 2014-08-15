require 'spec_helper'

describe UsersUnit do

  describe 'Validations' do
    it 'should have valid factory' do
      expect(FactoryGirl.build(:users_unit)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:group) }
  end

  describe 'Associations' do
    it { should belong_to(:group) }
    it { should have_db_index(:group_id) }
    it { should have_many(:users_unit_memberships).dependent(:destroy) }
    it { should have_many(:users).through(:users_unit_memberships) }
    it { should have_many(:admins).through(:users_unit_memberships) }
  end
end
