require 'rails_helper'

describe Group::GroupsSerializer do
  context 'Passing a collection of Group instances' do
    let(:first_group) { FactoryGirl.build(:group) }
    let(:second_group) { FactoryGirl.build(:group) }

    subject { described_class.new([first_group, second_group]).to_hash }

    it { should include(
      {
        id: first_group.id,
        name: first_group.name,
        created_at: first_group.created_at,
        updated_at: first_group.updated_at
      },
      {
        id: second_group.id,
        name: second_group.name,
        created_at: second_group.created_at,
        updated_at: second_group.updated_at
      }
    )}
  end
end
