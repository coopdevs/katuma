require 'rails_helper'

module BasicResources
  describe Membership do
    let(:user) do
      user = FactoryGirl.create(:user)
      User.find(user.id)
    end
    let(:group) { FactoryGirl.create(:group) }
    let(:producer) { FactoryGirl.create(:producer) }

    it 'has a valid factory' do
      expect(
        FactoryGirl.build(
          :membership,
          user: user,
          basic_resource_group_id: group.id
        )
      ).to be_valid
    end

    describe 'Validations' do
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_inclusion_of(:role).in_array(Membership::ROLES.values) }

      describe 'setting the actor' do
        context 'setting no `group_id` or `user_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              basic_resource_producer_id: producer.id,
            )
          end

          it { is_expected.to_not be_valid }
        end

        context 'setting both `group_id` and `user_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              basic_resource_producer_id: producer.id,
              user: user,
              group: group
            )
          end

          it { is_expected.to_not be_valid }
        end

        context 'setting only `group_id` and not `user_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              basic_resource_producer_id: producer.id,
              group: group
            )
          end

          it { is_expected.to be_valid }

          context 'with same `group_id` and `basic_resource_producer_id`' do
            before { subject.save! }

            it 'raises an error' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: producer.id,
                  group: group
                )
              end.to raise_error(ActiveRecord::RecordNotUnique)
            end
          end

          context 'with different `group_id` but same `basic_resource_producer_id`' do
            let(:other_group) do
              g = FactoryGirl.create(:group)
              Group.find(g.id)
            end

            before { subject.save }

            it 'lets create the record' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: producer.id,
                  group: other_group
                )
              end.to change { Membership.count }.from(1).to(2)
            end
          end
        end

        context 'setting only `user_id` and not `group_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              basic_resource_producer_id: producer.id,
              user: user
            )
          end

          it { is_expected.to be_valid }

          context 'with same `user_id` and `basic_resource_producer_id`' do
            before { subject.save }

            it 'raises an error' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: producer.id,
                  user: user
                )
              end.to raise_error(ActiveRecord::RecordNotUnique)
            end
          end

          context 'with different `user_id` but same `basic_resource_producer_id`' do
            let(:other_user) do
              u = FactoryGirl.create(:user)
              User.find(u.id)
            end

            before { subject.save }

            it 'lets create the record' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: producer.id,
                  user: other_user
                )
              end.to change { Membership.count }.from(1).to(2)
            end
          end
        end
      end

      describe 'setting the basic resource' do
        let(:user) do
          u = FactoryGirl.create(:user)
          User.find(u.id)
        end

        context 'setting no `basic_resource_group_id` or `basic_resource_producer_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              user: user
            )
          end

          it { is_expected.to_not be_valid }
        end

        context 'setting both `basic_resource_group_id` and `basic_resource_producer_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              user: user,
              basic_resource_group_id: group.id,
              basic_resource_producer_id: producer.id,
            )
          end

          it { is_expected.to_not be_valid }
        end

        context 'setting only `basic_resource_group_id` and not `basic_resource_producer_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              user: user,
              basic_resource_group_id: group.id
            )
          end

          it { is_expected.to be_valid }

          context 'with same `basic_resource_group_id` and `user_id`' do
            before { subject.save! }

            it 'raises an error' do
              expect do
                FactoryGirl.create(
                  :membership,
                  user: user,
                  basic_resource_group_id: group.id
                )
              end.to raise_error(ActiveRecord::RecordNotUnique)
            end
          end

          context 'with different `basic_resource_group_id` but same `user_id`' do
            let(:other_group) do
              g = FactoryGirl.create(:group)
              Group.find(g.id)
            end

            before { subject.save }

            it 'lets create the record' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_group_id: other_group.id,
                  user: user
                )
              end.to change { Membership.count }.from(1).to(2)
            end
          end
        end

        context 'setting only `basic_resource_producer_id` and not `basic_resource_group_id`' do
          subject do
            FactoryGirl.build(
              :membership,
              user: user,
              basic_resource_producer_id: producer.id
            )
          end

          it { is_expected.to be_valid }

          context 'with same `basic_resource_producer_id` and `user_id`' do
            before { subject.save }

            it 'raises an error' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: producer.id,
                  user: user
                )
              end.to raise_error(ActiveRecord::RecordNotUnique)
            end
          end

          context 'with different `basic_resource_producer_id` but same `user_id`' do
            let(:other_producer) { FactoryGirl.create(:producer) }

            before { subject.save }

            it 'lets create the record' do
              expect do
                FactoryGirl.create(
                  :membership,
                  basic_resource_producer_id: other_producer.id,
                  user: user
                )
              end.to change { Membership.count }.from(1).to(2)
            end
          end
        end
      end
    end

    describe 'Associations' do
      it { should belong_to(:group) }
      it { should belong_to(:user) }
    end
  end
end
