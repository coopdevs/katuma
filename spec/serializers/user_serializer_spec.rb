require 'spec_helper'

describe UserSerializer do

  context 'passing a User instance' do

    let(:user) { FactoryGirl.build(:user) }
    let(:hash) { UserSerializer.new(user).to_hash }

    subject(:users) { hash.fetch(:users) }

    it 'returns the correct user properties' do
      expect(users.first).to include(
        id: user.id,
        name: user.name,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      )
    end

    it 'does not include password_digest property' do
      expect(users.first).to_not include :password_digest
    end
  end
end
