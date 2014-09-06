require 'spec_helper'

describe UsersSerializer do

  context 'passing a collection of User instances' do

    let(:first_user) { FactoryGirl.build(:user) }
    let(:second_user) { FactoryGirl.build(:user) }

    subject { UsersSerializer.new([first_user, second_user]).to_hash }

    it { should include(
      {
        id: first_user.id,
        name: first_user.name,
        email: first_user.email,
        created_at: first_user.created_at,
        updated_at: first_user.updated_at
      },
      {
        id: second_user.id,
        name: second_user.name,
        email: second_user.email,
        created_at: second_user.created_at,
        updated_at: second_user.updated_at
      }
    )}
  end
end
