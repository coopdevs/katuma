require 'rails_helper'

module BasicResources
  describe ProducerCreator do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:producer) do
      Producer.new(
        name: 'Proveidor',
        email: 'proveidor@katuma.org',
        address: 'c/ dels Proveidors, 123'
      )
    end
    let(:producer_creator) do
      described_class.new(
        producer: producer,
        creator: user,
        group: group
      )
    end

    describe '#create!' do
      # before(:all) { ActiveRecord::Base.connection }

      subject { producer_creator.create! }

      context 'Without passing a `group`' do
        let(:group) { nil }

        it 'changes a new producer' do
          expect { subject }.to change(Producer, :count).from(0).to(1)
        end
        its(:persisted?) { is_expected.to be_truthy }
        its(:name) { is_expected.to eq(producer.name) }
        its(:email) { is_expected.to eq(producer.email) }
        its(:address) { is_expected.to eq(producer.address) }

        context 'when the producer is not valid' do
          let(:producer) { Producer.new(name: 'Proveidor') }

          it 'does not change the Producer.count' do
            expect { subject }.to_not change(Producer, :count)
          end
        end
      end

      context 'Passing a `group`' do
        let(:group) { FactoryGirl.create(:group) }

        it 'changes a new producer' do
          expect { subject }.to change(Producer, :count).from(0).to(1)
        end
        its(:persisted?) { is_expected.to be_truthy }
        its(:name) { is_expected.to eq(producer.name) }
        its(:email) { is_expected.to eq(producer.email) }
        its(:address) { is_expected.to eq(producer.address) }

        context 'when the producer is not valid' do
          let(:producer) { Producer.new(name: 'Proveidor') }

          it 'does not change the Producer.count' do
            expect { subject }.to_not change(Producer, :count)
          end
        end
      end

      describe '@side_effects' do
        before { producer_creator.create! }

        subject { producer_creator.side_effects }

        context 'Without passing a `group`' do
          let(:group) { nil }

          it { is_expected.to be_kind_of(Array) }
          its(:length) { is_expected.to eq(1) }
          its(:first) { is_expected.to be_kind_of(Membership) }

          it 'includes a membership between the producer and the creator' do
            membership = subject.first

            expect(membership.persisted?).to be_truthy
            expect(membership.basic_resource_producer_id).to be(producer.id)
            expect(membership.user).to be(user)
            expect(membership.group).to be_nil
            expect(membership.role).to be(Membership::ROLES[:admin])
          end
        end

        context 'Passing a `group`' do
          let(:group) { FactoryGirl.create(:group) }
          let(:membership) do
            FactoryGirl.create(
              :membership,
              basic_resource_group_id: group.id,
              user: user
            )
          end

          it 'includes a membership between the producer and the group' do
            membership = subject.first

            expect(membership.persisted?).to be_truthy
            expect(membership.basic_resource_producer_id).to be(producer.id)
            expect(membership.group).to be(group)
            expect(membership.user).to be_nil
            expect(membership.role).to be(Membership::ROLES[:admin])
          end
        end
      end
    end
  end
end
