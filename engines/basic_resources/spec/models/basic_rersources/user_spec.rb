require 'rails_helper'

module BasicResources
  describe User do
    describe 'Associations' do
      it { should have_many(:memberships).dependent(:destroy) }
      it { should have_many(:groups).through(:memberships) }
    end
  end
end
