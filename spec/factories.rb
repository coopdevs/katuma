FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :user, class: Account::User do
    first_name 'Jessie'
    last_name 'Pinkman'
    username 'jess'
    email
    password 'secret'
    password_confirmation 'secret'
  end

  factory :group, class: Group::Group do
    name "Group"

    # after :build do |g|
      # g.users_units.build(name: "My UsersUnit")
    # end
  end
end
