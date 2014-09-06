# spec/models/membership_spec.rb
require 'spec_helper'

describe Membership do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:membership)).to be_valid
  end

  describe 'Validations' do
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }
    it { should ensure_inclusion_of(:role)
         .in_array(UsersUnitMembership::ROLES.values)
    }
    it {
      FactoryGirl.create :membership
      should validate_uniqueness_of(:user_id).scoped_to(:group_id)
    }
  end

  describe 'Associations' do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
  end
end
