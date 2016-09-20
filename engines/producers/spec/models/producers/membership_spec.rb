require 'rails_helper'

module Producers
  describe Membership do
    let(:user) do
      u = FactoryGirl.create(:user)
      User.find(u.id)
    end
    let(:group) do
      g = FactoryGirl.create(:group)
      Group.find(g.id)
    end

    describe 'Validations' do
      it 'has a valid factory' do
        expect(
          FactoryGirl.build(
            :producers_membership,
            group: group
          )
        ).to be_valid
      end

      it { is_expected.to validate_presence_of(:producer) }
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_inclusion_of(:role).in_array(Membership::ROLES.values) }

      context 'setting no `group_id` or `user_id`' do
        subject { FactoryGirl.build(:producers_membership) }

        it 'is not valid' do
          expect(subject.valid?).to be_falsey
        end
      end

      context 'setting both `group_id` and `user_id`' do
        subject do
          FactoryGirl.build(
            :producers_membership,
            user: user,
            group: group
          )
        end

        it 'is not valid' do
          expect(subject.valid?).to be_falsey
        end
      end

      context 'setting only `group_id` and not `user_id`' do
        subject do
          FactoryGirl.build(
            :producers_membership,
            group: group
          )
        end

        it 'is valid' do
          expect(subject.valid?).to be_truthy
        end

        context 'with same `group_id` and `producer_id`' do
          let(:producer) { subject.producer }

          before { subject.save }

          it 'raises an error' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: producer,
                group: group
              )
            end.to raise_error(ActiveRecord::RecordNotUnique)
          end
        end

        context 'with different `group_id` but same `producer_id`' do
          let(:other_group) do
            g = FactoryGirl.create(:group)
            Group.find(g.id)
          end
          let(:producer) { subject.producer }

          before { subject.save }

          it 'lets create the record' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: producer,
                group: other_group
              )
            end.to change { Membership.count }.from(1).to(2)
          end
        end

        context 'with different `group_id` and different `producer_id`' do
          let(:other_group) do
            g = FactoryGirl.create(:group)
            Group.find(g.id)
          end
          let(:other_producer) { FactoryGirl.create(:producer) }

          before { subject.save }

          it 'lets create the record' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: other_producer,
                group: other_group
              )
            end.to change { Membership.count }.from(1).to(2)
          end
        end
      end

      context 'setting only `user_id` and not `group_id`' do
        subject do
          FactoryGirl.build(
            :producers_membership,
            user: user
          )
        end

        it 'is valid' do
          expect(subject.valid?).to be_truthy
        end

        context 'with same `user_id` and `producer_id`' do
          let(:producer) { subject.producer }

          before { subject.save }

          it 'raises an error' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: producer,
                user: user
              )
            end.to raise_error(ActiveRecord::RecordNotUnique)
          end
        end

        context 'with different `user_id` but same `producer_id`' do
          let(:other_user) do
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:producer) { subject.producer }

          before { subject.save }

          it 'lets create the record' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: producer,
                user: other_user
              )
            end.to change { Membership.count }.from(1).to(2)
          end
        end

        context 'with different `user_id` and different `producer_id`' do
          let(:other_user) do
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:other_producer) { FactoryGirl.create(:producer) }

          before { subject.save }

          it 'lets create the record' do
            expect do
              FactoryGirl.create(
                :producers_membership,
                producer: other_producer,
                user: other_user
              )
            end.to change { Membership.count }.from(1).to(2)
          end
        end
      end
    end

    describe 'Associations' do
      it { should belong_to(:producer) }
      it { should belong_to(:user) }
      it { should belong_to(:group) }
    end
  end
end
