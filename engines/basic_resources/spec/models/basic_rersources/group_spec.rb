require 'rails_helper'

module BasicResources
  describe Group do
    describe 'Validations' do
      before { FactoryGirl.build(:user) }

      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'Associations' do
      it { is_expected.to have_many(:memberships).dependent(:destroy) }
      it { is_expected.to have_many(:users).through(:memberships) }
      it { is_expected.to have_many(:admins).through(:memberships) }
      it { is_expected.to have_many(:waiters).through(:memberships) }
    end
  end
end
