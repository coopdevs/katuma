require 'rails_helper'

module BasicResources
  describe UsersCollection do
    describe '#build' do
      subject(:users) { described_class.new(group).build }

      let(:user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }
      let(:other_group) { FactoryGirl.create(:group) }

      let(:member) { FactoryGirl.create(:user) }
      let(:admin) { FactoryGirl.create(:user) }
      let(:member_of_other_group) { FactoryGirl.create(:user) }

      before do
        Membership.create(
          basic_resource_group_id: group.id,
          user_id: member.id,
          role: Membership::ROLES[:member]
        )
        Membership.create(
          basic_resource_group_id: group.id,
          user_id: admin.id,
          role: Membership::ROLES[:admin]
        )
        Membership.create(
          basic_resource_group_id: other_group.id,
          user_id: member_of_other_group.id,
          role: Membership::ROLES[:member]
        )
      end

      describe 'ids' do
        subject { users.map(&:id) }
        it { is_expected.to contain_exactly(member.id, admin.id) }
      end
    end
  end
end
