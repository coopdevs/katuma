FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@katuma.coop"
  end

  factory :user do
    name "My UF"
    email
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
end

