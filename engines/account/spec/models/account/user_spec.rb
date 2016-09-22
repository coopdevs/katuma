require 'rails_helper'

describe Account::User do
  describe 'Validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:user)).to be_valid
    end
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it do
      FactoryGirl.create :user
      is_expected.to validate_uniqueness_of(:username)
    end
    it do
      FactoryGirl.create :user
      is_expected.to validate_uniqueness_of(:email)
    end
  end
end
