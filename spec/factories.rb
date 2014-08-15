FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :user do
    name 'Jessie Pinkman'
    email
    password 'secret'
    password_confirmation 'secret'
  end

  factory :users_unit do
    name 'My unit'
    group
  end

  factory :group do
    name 'My group'
  end

  factory :membership do
    role 1
    group
    user
  end

  factory :users_unit_membership do
    role 1
    users_unit
    user
  end
end

