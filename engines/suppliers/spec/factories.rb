require 'ice_cube'

FactoryGirl.define do
  factory :supplier, class: Suppliers::Supplier do
  end

  factory :schedule, class: IceCube::Schedule do
    skip_create
    after(:build) do |schedule|
      schedule.add_recurrence_rule(IceCube::Rule.weekly)
    end
  end

  factory :orders_frequency, class: Suppliers::OrdersFrequency do
    trait :confirmation do
      frequency_type Suppliers::FrequencyType.new(:confirmation).to_s
    end
  end

  factory :order, class: Suppliers::Order do
    confirm_before Time.now.utc

    trait :from_user_to_group do
      to_group_id do
        group = FactoryGirl.create(:group)
        group = Suppliers::Group.find(group.id)
        group.id
      end

      from_user_id do
        user = FactoryGirl.create(:user)
        user = Suppliers::User.find(user.id)
        user.id
      end
    end
  end

  factory :order_line, class: Suppliers::OrderLine do
  end
end
