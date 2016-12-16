FactoryGirl.define do
  factory :supplier, class: Suppliers::Supplier do
  end

  factory :orders_frequency, class: Suppliers::OrdersFrequency do
  end

  factory :order, class: Suppliers::Order do
  end

  factory :order_line, class: Suppliers::OrderLine do
  end
end
