require 'spec_helper'

describe GroupSerializer do

  context 'passing a Group instance' do

    let(:group) { FactoryGirl.build(:group) }
    let(:hash) { GroupSerializer.new(group).to_hash }

    subject(:groups) { hash.fetch(:groups) }

    it 'returns the correct group properties' do
      expect(groups.first).to include(
        id: group.id,
        name: group.name,
        created_at: group.created_at,
        updated_at: group.updated_at
      )
    end
  end
end
