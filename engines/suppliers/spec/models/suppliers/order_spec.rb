require 'rails_helper'

module Suppliers
  describe Order do
    describe 'Validations' do
      let(:user) do
        user = FactoryGirl.create(:user)
        Suppliers::User.find(user.id)
      end

      let(:group) do
        group = FactoryGirl.create(:group)
        Suppliers::Group.find(group.id)
      end

      it { is_expected.to validate_presence_of(:confirm_before) }

      context 'when there is no actor' do
        subject { FactoryGirl.build(:order, from_user_id: nil) }
        it { is_expected.not_to be_valid }
      end

      context 'when there are both user and group as actors' do
        subject { FactoryGirl.build(:order, from_group_id: group.id) }
        it { is_expected.not_to be_valid }
      end

      context 'when there is no target' do
        subject { FactoryGirl.build(:order, to_group_id: nil) }
        it { is_expected.not_to be_valid }
      end

      context 'when there are both group and producer as targets' do
        subject { FactoryGirl.build(:order, to_producer_id: user.id) }
        it { is_expected.not_to be_valid }
      end

      context 'when there is an actor and a target' do
        subject { FactoryGirl.build(:order) }
        it { is_expected.to be_valid }
      end
    end

    describe 'Associations' do
      it { is_expected.to have_many(:order_lines) }

      it { is_expected.to belong_to(:from_user) }
      it { is_expected.to belong_to(:from_group) }

      it { is_expected.to belong_to(:to_group) }
      it { is_expected.to belong_to(:to_producer) }
    end
  end
end
