require 'rails_helper'

module BasicResources
  describe Producer do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:producer)).to be_valid
    end

    describe 'Validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:address) }
    end

    describe 'Associations' do
      it { is_expected.to have_many(:memberships).dependent(:destroy) }
    end
  end
end
