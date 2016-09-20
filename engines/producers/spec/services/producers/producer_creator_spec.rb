require 'rails_helper'

module Producers
  describe ProducerCreator do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:producer) do
      Producer.new(
        name: 'Proveidor',
        email: 'proveider@katuma.org',
        address: 'c/ dels Proveidors, 123'
      )
    end
    let(:creator) do
      described_class.new(
        producer: producer,
        creator: user,
        group: group
      )
    end

    describe '#create' do
      before(:all) { ActiveRecord::Base.connection }

      let(:group) { nil }

      subject { creator.create }

      it 'does not change the Producer.count' do
        expect { subject }.to change(Producer, :count)
      end

      describe 'its attributes' do
        before { creator.create }

        subject { Producer.last }

        its(:name) { is_expected.to eq(producer.name) }
        its(:email) { is_expected.to eq(producer.email) }
        its(:address) { is_expected.to eq(producer.address) }
      end

      context 'when something fails' do
        before { allow(creator).to receive(:create_membership_for_creator_or_group).and_raise }

        xit 'rollbacks the transaction' do
          expect do
            subject
          end.to raise_error(ActiveRecord::Rollback)
        end
      end

      context 'when the provider is not valid' do
        let(:producer) { Producer.new(name: 'Proveidor') }

        it { is_expected.to be_falsey }
        it 'does not change the Producer.count' do
          expect { subject }.to_not change(Producer, :count)
        end
      end

      describe '@side_effects' do
        before { creator.create }

        subject { creator.side_effects }

        it { is_expected.to be_kind_of(Array) }
        its(:length) { is_expected.to eq(1) }
        its(:first) { is_expected.to be_kind_of(::Producers::Membership)}

        context 'not passing a `group`' do
          let(:group) { nil }

          it 'includes a membership between the producer and the creator' do
            membership = subject.first

            expect(membership.persisted?).to be_truthy
            expect(membership.producer).to be(producer)
            expect(membership.user).to be(user)
            expect(membership.group).to be_nil
            expect(membership.role).to be(::Producers::Membership::ROLES[:admin])
          end
        end

        context 'passing a `group`' do
          let(:membership) { FactoryGirl.create(:membership, user: ::Group::User.find(user.id)) }
          let(:group) { ::Producers::Group.find(membership.group_id) }

          it 'includes a membership between the producer and the group' do
            membership = subject.first

            expect(membership.persisted?).to be_truthy
            expect(membership.producer).to be(producer)
            expect(membership.group).to be(group)
            expect(membership.user).to be_nil
            expect(membership.role).to be(::Producers::Membership::ROLES[:admin])
          end
        end
      end
    end
  end
end
