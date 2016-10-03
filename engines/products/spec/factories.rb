FactoryGirl.define do
  factory :product, class: Products::Product do
    name 'Manzana'
    price 10.13
    unit 0
    producer
  end
end
