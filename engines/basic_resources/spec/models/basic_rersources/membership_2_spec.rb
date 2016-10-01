require 'rails_helper'

module BasicResources
  describe Membership do
    let(:user) do
      u = FactoryGirl.create(:user)
      User.find(u.id)
    end
    let(:group) do
      g = FactoryGirl.create(:group)
      Group.find(g.id)
    end

    describe 'Validations' do
      it 'has a valid factory' do
        expect(
          FactoryGirl.build(
            :producers_membership,
            group: group
          )
        ).to be_valid
      end

      it { is_expected.to validate_presence_of(:producer) }
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_inclusion_of(:role).in_array(Membership::ROLES.values) }
    end

    describe 'Associations' do
      it { should belong_to(:producer) }
      it { should belong_to(:user) }
      it { should belong_to(:group) }
    end
  end
end
