require 'rails_helper'

module BasicResources
  describe GroupSerializer do
    context 'passing a Group instance' do
      let(:group) { FactoryGirl.create(:group) }

      subject { described_class.new(group).to_hash }

      it 'returns the expected attributes' do
        is_expected.to include(
          id: group.id,
          name: group.name,
          created_at: group.created_at,
          updated_at: group.updated_at
        )
      end
    end
  end
end
