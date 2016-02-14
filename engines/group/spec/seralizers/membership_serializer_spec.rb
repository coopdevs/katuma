require 'spec_helper'

describe Group::MembershipSerializer do

  context 'passing a Membership instance' do

    let(:group) { FactoryGirl.build(:group) }
    let(:user) { FactoryGirl.build(:user) }
    let(:membership) do
      FactoryGirl.build(:membership, group: group, user: user, role: Membership::ROLES[:admin])
    end

    subject { MembershipSerializer.new(membership).to_hash }

    it { should include(
        id: membership.id,
        group_id: group.id,
        user_id: user.id,
        role: 1,
        created_at: group.created_at,
        updated_at: group.updated_at
    )}
  end
end
