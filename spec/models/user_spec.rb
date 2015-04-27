require 'rails_helper'
require 'shoulda/matchers'

describe Account::User do

  describe 'Validations' do
    xit 'has a valid factory' do
      expect(FactoryGirl.build(:user)).to be_valid
    end
    xit { should validate_presence_of(:username) }
    xit { should validate_presence_of(:email) }
    xit { FactoryGirl.create :user
         should validate_uniqueness_of(:username) }
    xit { FactoryGirl.create :user
         should validate_uniqueness_of(:email) }
  end
end
