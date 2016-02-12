require 'spec_helper'

describe Group::GroupSerializer do

  context 'passing a Group instance' do

    let(:group) { FactoryGirl.build(:group) }

    subject { GroupSerializer.new(group).to_hash }

    it { should include(
        id: group.id,
        name: group.name,
        created_at: group.created_at,
        updated_at: group.updated_at
    )}
  end
end
