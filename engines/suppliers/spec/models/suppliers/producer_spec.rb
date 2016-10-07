require 'rails_helper'

module Suppliers
  describe Producer do
    describe 'Associations' do
      it { is_expected.to have_many(:memberships).with_foreign_key(:basic_resource_producer_id) }
      it { is_expected.to have_many(:groups).through(:memberships) }
    end

    describe '#has_admin?' do
      let(:user) { FactoryGirl.create(:user) }
      let(:producer) do
        producer = FactoryGirl.create(:producer)
        described_class.find(producer.id)
      end

      subject { producer.has_admin?(user) }

      context 'when the user is not associated to the producer' do
        it { is_expected.to be_falsey }
      end

      context 'when the user is associated to the producer' do
        before do
          FactoryGirl.create(
            :membership,
            basic_resource_producer_id: producer.id,
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
