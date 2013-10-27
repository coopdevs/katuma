FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :user do
    name "Jessie Pinkman"
    email
  end

  factory :users_unit do
    name "My family"
    customer
  end

  factory :supplier do
    name "Supplier"
  end

  factory :customer do
    name "Customer"
  end

  factory :membership do
    association :member, :factory => :user
    association :memberable, :factory => :customer
  end

  factory :order do
    customer
    association :provider, :factory => :supplier
  end

  factory :waiting_list do
    customer
  end

  factory :waiting_user do
    waiting_list
    user
  end
end

