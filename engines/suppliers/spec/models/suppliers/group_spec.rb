require 'rails_helper'

module Suppliers
  describe Group do
    describe 'Associations' do
      it { is_expected.to have_many(:suppliers) }
      it { is_expected.to have_many(:producers).through(:suppliers) }
      it { is_expected.to have_many(:memberships).with_foreign_key(:basic_resource_group_id) }
    end

    describe '#has_admin?' do
      let(:user) { FactoryGirl.create(:user) }
      let(:group) do
        group = FactoryGirl.create(:group)
        described_class.find(group.id)
      end

      subject { group.has_admin?(user) }

      context 'when the user is not associated to the group' do
        it { is_expected.to be_falsey }
      end

      context 'when the user is associated to the group' do
        before do
          FactoryGirl.create(
            :membership,
            basic_resource_group_id: group.id,
            user_id: user.id,
            role: role
          )
        end

        context 'as an `admin`' do
          let(:role) { Membership::ROLES[:admin] }

          it { is_expected.to be_truthy }
        end

        context 'as a `member`' do
          let(:role) { Membership::ROLES[:member] }

          it { is_expected.to be_falsey }
        end
      end
    end
  end
end
