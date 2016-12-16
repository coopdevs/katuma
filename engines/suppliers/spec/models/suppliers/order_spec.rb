require 'rails_helper'

module Suppliers
  describe Order do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:group) do
      group = FactoryGirl.create(:group)
      Group.find(group.id)
    end

    describe 'Validations' do
      it 'has a valid factory' do
        expect(
          FactoryGirl.build(
            :order,
            user: user,
            group: group,
            confirm_before: Time.now.utc
          )
        ).to be_valid
      end

      it { is_expected.to validate_presence_of(:user) }
      it { is_expected.to validate_presence_of(:group) }
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to belong_to(:group) }
    end
  end
end
