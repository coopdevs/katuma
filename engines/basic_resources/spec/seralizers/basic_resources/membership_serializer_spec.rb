require 'rails_helper'

module BasicResources
  describe MembershipSerializer do
    context 'Passing a Membership instance' do
      let(:group) { FactoryGirl.build(:group) }
      let(:user) do
        user = FactoryGirl.create(:user)
        User.find(user.id)
      end
      let(:membership) do
        FactoryGirl.build(:membership, group: group, user: user, role: Membership::ROLES[:admin])
      end

      subject { MembershipSerializer.new(membership).to_hash }

      it do
        is_expected.to include(
          id: membership.id,
          group_id: group.id,
          user_id: user.id,
          role: 1,
          created_at: group.created_at,
          updated_at: group.updated_at
        )
      end
    end
  end
end
