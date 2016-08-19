require 'rails_helper'

describe Group::Membership do

  let(:user) do
    user = FactoryGirl.create(:user)
    Group::User.find(user.id)
  end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:membership, user: user)).to be_valid
  end

  describe 'Validations' do
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }
    it {
      FactoryGirl.create(:membership, user: user)
      should validate_uniqueness_of(:user_id).scoped_to(:group_id)
    }
  end

  describe 'Associations' do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
  end
end
