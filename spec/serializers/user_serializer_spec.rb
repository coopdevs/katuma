require 'spec_helper'

describe Account::UserSerializer do

  context 'passing a User instance' do

    let(:user) { FactoryGirl.build(:user) }

    subject { UserSerializer.new(user).to_hash }

    it { should include(
        id: user.id,
        name: user.name,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      )
    }

    it { should_not include :password_digest }
  end
end
