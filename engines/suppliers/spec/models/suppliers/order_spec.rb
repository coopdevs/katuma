require 'rails_helper'

module Suppliers
  describe Order do
    describe 'Validations' do
      it { is_expected.to validate_presence_of(:user) }

      context 'when there is no actor' do
        subject { FactoryGirl.build(:order, from_user_id: nil) }
        it { is_expected.not_to be_valid }
      end

      context 'when there is an actor' do
        subject { FactoryGirl.build(:order) }
        it { is_expected.to be_valid }
      end
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to belong_to(:group) }
    end
  end
end
