FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end
  sequence :username do |n|
    "jess#{n}"
  end

  factory :user, class: Account::User do
    first_name 'Jessie'
    last_name 'Pinkman'
    username
    email
    password 'secret'
    password_confirmation 'secret'
  end
end
