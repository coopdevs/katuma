FactoryGirl.define do
  factory :product, class: Producers::Product do
    name 'Manzana'
    price 10.13
    unit 0
    producer
  end
end
