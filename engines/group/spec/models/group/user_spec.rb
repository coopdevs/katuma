require 'rails_helper'

describe Group::User do
  describe 'Associations' do
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:groups).through(:memberships) }
  end
end
