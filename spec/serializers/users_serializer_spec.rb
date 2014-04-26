require 'spec_helper'

describe UsersSerializer do

  context 'passing a collection of User instances' do

    let(:first_user) { FactoryGirl.build(:user) }
    let(:second_user) { FactoryGirl.build(:user) }
    let(:hash) { UsersSerializer.new([first_user, second_user]).to_hash }

    subject(:users) { hash.fetch(:users) }

    it 'returns the correct first_user properties' do
      expect(users[0]).to include(
        id: first_user.id,
        name: first_user.name,
        created_at: first_user.created_at,
        updated_at: first_user.updated_at
      )
    end

    it 'returns the correct second_user properties' do
      expect(users[0]).to include(
        id: second_user.id,
        name: second_user.name,
        created_at: second_user.created_at,
        updated_at: second_user.updated_at
      )
    end
  end
end
