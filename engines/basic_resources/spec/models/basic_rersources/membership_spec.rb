require 'rails_helper'

module BasicResources
  describe Membership do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end

    it 'has a valid factory' do
      expect(FactoryGirl.build(:membership, user: user)).to be_valid
    end

    describe 'Validations' do
      it { should validate_presence_of(:group) }
      it { should validate_presence_of(:user) }
      it { should validate_presence_of(:role) }
      it do
        FactoryGirl.create(:membership, user: user)
        should validate_uniqueness_of(:user_id).scoped_to(:group_id)
      end
    end

    describe 'Associations' do
      it { should belong_to(:group) }
      it { should belong_to(:user) }
    end
  end
end
