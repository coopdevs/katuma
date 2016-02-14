require 'rails_helper'
require 'shoulda/matchers'

describe Group::Group do

  describe 'Validations' do

    xit 'has a valid factory' do
      expect(FactoryGirl.build(:group)).to be_valid
    end

    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do

    xit { should have_many(:memberships).dependent(:destroy) }
    xit { should have_many(:users).through(:memberships) }
    xit { should have_many(:admins).through(:memberships) }
    xit { should have_many(:waiters).through(:memberships) }
  end
end
