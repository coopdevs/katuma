require 'rails_helper'

module BasicResources
  describe MembershipsSerializer do
    context 'passing a collection of Membership instances' do
      let(:user) do
        user = FactoryGirl.create(:user)
        User.find(user.id)
      end
      let(:first_group) { FactoryGirl.create(:group) }
      let(:second_group) { FactoryGirl.create(:group) }
      let(:first_membership) do
        FactoryGirl.create(
          :membership,
          basic_resource_group_id: first_group.id,
          user: user,
          role: Membership::ROLES[:admin]
        )
      end
      let(:second_membership) do
        FactoryGirl.create(
          :membership,
          basic_resource_group_id: second_group.id,
          user: user,
          role: Membership::ROLES[:admin]
        )
      end

      subject { MembershipsSerializer.new([first_membership, second_membership]).to_hash }

      it 'returns the expected attributes' do
        is_expected.to include(
          {
            id: first_membership.id,
            basic_resource_group_id: first_group.id,
            basic_resource_producer_id: nil,
            group_id: nil,
            user_id: user.id,
            role: first_membership.role,
            created_at: first_membership.created_at,
            updated_at: first_membership.updated_at
          },
          {
            id: second_membership.id,
            basic_resource_group_id: second_group.id,
            basic_resource_producer_id: nil,
            group_id: nil,
            user_id: user.id,
            role: second_membership.role,
            created_at: second_membership.created_at,
            updated_at: second_membership.updated_at
          }
        )
      end
    end
  end
end
