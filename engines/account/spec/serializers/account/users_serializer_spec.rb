require 'rails_helper'

describe Account::UsersSerializer do
  context 'passing a collection of User instances' do
    let(:first_user) { FactoryGirl.build(:user) }
    let(:second_user) { FactoryGirl.build(:user) }

    subject { described_class.new([first_user, second_user]).to_hash }

    it { should include(
      {
        id: first_user.id,
        full_name: first_user.full_name,
        first_name: first_user.first_name,
        last_name: first_user.last_name,
        username: first_user.username,
        email: first_user.email,
        created_at: first_user.created_at,
        updated_at: first_user.updated_at
      },
      {
        id: second_user.id,
        full_name: second_user.full_name,
        first_name: second_user.first_name,
        last_name: second_user.last_name,
        username: second_user.username,
        email: second_user.email,
        created_at: second_user.created_at,
        updated_at: second_user.updated_at
      }
    )}
  end
end
