require 'rails_helper'

module BasicResources
  describe MembershipsCollection do
    describe '#build' do
      subject(:memberships) { described_class.new(joanin, group).build }

      let(:group1) { FactoryGirl.create(:group) }
      let(:group2) { FactoryGirl.create(:group) }
      let(:joanin) { FactoryGirl.create(:user) }
      let(:frida) { FactoryGirl.create(:user) }
      let(:merce) { FactoryGirl.create(:user) }
      let!(:group1_membership_joanin) do
        Membership.create!(
          basic_resource_group_id: group1.id,
          user_id: joanin.id,
          role: MemberRole.new(:admin)
        )
      end
      let!(:group1_membership_frida) do
        Membership.create!(
          basic_resource_group_id: group1.id,
          user_id: frida.id,
          role: MemberRole.new(:member)
        )
      end
      let!(:group1_membership_merce) do
        Membership.create!(
          basic_resource_group_id: group1.id,
          user_id: merce.id,
          role: MemberRole.new(:member)
        )
      end
      let!(:group2_membership_joanin) do
        Membership.create!(
          basic_resource_group_id: group2.id,
          user_id: joanin.id,
          role: MemberRole.new(:member)
        )
      end

      context 'when no group is provided' do
        let(:group) { nil }

        it do
          is_expected.to contain_exactly(
            group1_membership_joanin,
            group2_membership_joanin
          )
        end
      end

      context 'when group is provided' do
        let(:group) { group1 }

        it do
          is_expected.to contain_exactly(
            group1_membership_joanin,
            group1_membership_frida,
            group1_membership_merce
          )
        end
      end
    end
  end
end
