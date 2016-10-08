require 'rails_helper'

module BasicResources
  describe User do
    describe 'Associations' do
      it { is_expected.to have_many(:memberships).dependent(:destroy) }
      it { is_expected.to have_many(:groups).through(:memberships) }
      it { is_expected.to have_many(:producers).through(:memberships) }
    end
  end
end
