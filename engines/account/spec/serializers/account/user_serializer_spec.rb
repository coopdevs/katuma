require 'rails_helper'

describe Account::UserSerializer do
  context 'passing a User instance' do
    let(:user) { FactoryGirl.build(:user) }

    subject { described_class.new(user).to_hash }

    it { should include(
        id: user.id,
        full_name: user.full_name,
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      )
    }

    it { should_not include :password_digest }
  end
end
