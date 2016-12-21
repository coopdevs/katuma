FactoryGirl.define do
  factory :supplier, class: Suppliers::Supplier do
  end

  factory :orders_frequency, class: Suppliers::OrdersFrequency do
    trait :confirmation do
      frequency_type Suppliers::OrdersFrequency::FREQUENCY_TYPES[:confirmation]
    end
  end

  factory :order, class: Suppliers::Order do
  end

  factory :order_line, class: Suppliers::OrderLine do
  end
end
