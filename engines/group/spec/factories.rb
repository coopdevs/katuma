FactoryGirl.define do
  factory :group, class: Group::Group do
    name 'Group'
  end

  factory :membership, class: Group::Membership do
    group
    role 1
  end
end
