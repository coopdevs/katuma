FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :user do
    name "Jessie Pinkman"
    email
    password "secret"
    password_confirmation "secret"
  end

  factory :users_unit do
    name "My family"
    group
  end

  factory :group do
    name "My group"

    after :build do |g|
      g.users_units.build(name: "My UsersUnit")
    end
  end

  factory :users_unit_membership do
    users_unit
    user
  end

  factory :waiting_list_membership do
    group
    user
  end
end

