require 'rails_helper'

describe Group::Group do
  describe 'Validations' do
    before { FactoryGirl.build(:user) }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Associations' do
    xit { is_expected.to have_many(:memberships).dependent(:destroy) }
    xit { is_expected.to have_many(:users).through(:memberships) }
    xit { is_expected.to have_many(:admins).through(:memberships) }
    xit { is_expected.to have_many(:waiters).through(:memberships) }
  end
end
