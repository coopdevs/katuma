require 'rails_helper'

module BasicResources
  describe MembershipsCollection do
    describe '#build' do
      subject(:memberships) { described_class.new(user, group).build }

      let(:user) { FactoryGirl.create(:user) }
      let!(:some_group_membership) do
        Membership.create!(
          basic_resource_group_id: FactoryGirl.create(:group).id,
          user_id: user.id,
          role: MemberRole.new(:member)
        )
      end

      context 'when no group is provided' do
        let(:group) { nil }

        describe 'ids' do
          subject { memberships.map(&:id) }
          it { is_expected.to contain_exactly(some_group_membership.id) }
        end
      end

      context 'when group is provided' do
        let(:group) { FactoryGirl.create(:group) }

        let!(:group_membership) do
          Membership.create!(
            basic_resource_group_id: group.id,
            user_id: user.id,
            role: MemberRole.new(:member)
          )
        end

        describe 'ids' do
          subject { memberships.map(&:id) }
          it { is_expected.to contain_exactly(group_membership.id) }
        end
      end
    end
  end
end
