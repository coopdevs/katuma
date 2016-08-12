require 'rails_helper'

module Group
  describe MembershipsSerializer do
    context 'passing a collection of Membership instances' do
      let(:user) do
        user = FactoryGirl.create(:user)
        User.find(user.id)
      end
      let(:first_membership) { FactoryGirl.build(:membership, user: user) }
      let(:second_membership) { FactoryGirl.build(:membership, user: user) }

      subject { MembershipsSerializer.new([first_membership, second_membership]).to_hash }

      it { should include(
        {
          id: first_membership.id,
          group_id: first_membership.group.id,
          user_id: first_membership.user.id,
          role: first_membership.role,
          created_at: first_membership.created_at,
          updated_at: first_membership.updated_at
        },
        {
          id: second_membership.id,
          group_id: second_membership.group.id,
          user_id: second_membership.user.id,
          role: second_membership.role,
          created_at: second_membership.created_at,
          updated_at: second_membership.updated_at
        }
      )}
    end
  end
end
