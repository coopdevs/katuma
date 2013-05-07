FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@katuma.coop"
  end

  factory :user do
    name "My UF"
    email
  end
end

