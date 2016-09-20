FactoryGirl.define do
  factory :producer, class: Producers::Producer do
    name 'Producer'
    email 'producer@katuma.org'
    address 'c/ dels Productors, 12'
  end

  factory :producers_membership, class: Producers::Membership do
    producer
    role 1
  end
end
