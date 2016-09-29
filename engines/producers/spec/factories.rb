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

  factory :product, class: Producers::Product do
    name 'Manzana'
    price 10
    unit 0
    producer
  end
end
