require 'rails_helper'
require 'shoulda/matchers'

describe Membership do

  xit 'has a valid factory' do
    expect(FactoryGirl.build(:membership)).to be_valid
  end

  describe 'Validations' do
    xit { should validate_presence_of(:group) }
    xit { should validate_presence_of(:user) }
    xit { should validate_presence_of(:role) }
    xit { should validate_inclusion_of(:role)
         .in_array(UsersUnitMembership::ROLES.values)
    }
    xit {
      FactoryGirl.create :membership
      should validate_uniqueness_of(:user_id).scoped_to(:group_id)
    }
  end

  describe 'Associations' do
    xit { should belong_to(:group) }
    xit { should belong_to(:user) }
  end
end
