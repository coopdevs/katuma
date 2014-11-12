require 'rails_helper'
require 'shoulda/matchers'

describe UsersUnitMembership do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:users_unit_membership)).to be_valid
  end

  describe 'Validations' do
    it { should validate_presence_of(:users_unit) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role)
         .in_array(UsersUnitMembership::ROLES.values)
    }
    it {
      FactoryGirl.create :users_unit_membership
      should validate_uniqueness_of(:user_id).scoped_to(:users_unit_id)
    }
  end

  describe 'Associations' do
    it { should belong_to(:users_unit) }
    it { should belong_to(:user) }
  end
end
