require 'spec_helper'

describe GroupsSerializer do

  context 'passing a collection of Group instances' do

    let(:first_group) { FactoryGirl.build(:group) }
    let(:second_group) { FactoryGirl.build(:group) }
    let(:hash) { GroupsSerializer.new([first_group, second_group]).to_hash }

    subject(:groups) { hash.fetch(:groups) }

    it 'returns the correct first_group properties' do
      expect(groups[0]).to include(
        id: first_group.id,
        name: first_group.name,
        created_at: first_group.created_at,
        updated_at: first_group.updated_at
      )
    end

    it 'returns the correct second_group properties' do
      expect(groups[0]).to include(
        id: second_group.id,
        name: second_group.name,
        created_at: second_group.created_at,
        updated_at: second_group.updated_at
      )
    end
  end
end
