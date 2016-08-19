require 'rails_helper'

describe Account::User do
  describe 'Validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:user)).to be_valid
    end
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { FactoryGirl.create :user
        should validate_uniqueness_of(:username) }
    it { FactoryGirl.create :user
         should validate_uniqueness_of(:email) }
  end
end
