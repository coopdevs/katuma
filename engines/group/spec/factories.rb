FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :group, class: Group::Group do
    name "Group"
  end

  factory :user, class: Group::User do
    first_name 'Jessie'
    last_name 'Pinkman'
    username 'jess'
    email
    password 'secret'
    password_confirmation 'secret'
  end
end
