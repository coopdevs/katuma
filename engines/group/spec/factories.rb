FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@katuma.org"
  end

  factory :group, class: Group::Group do
    name "Group"

    # after :build do |g|
      # g.users_units.build(name: "My UsersUnit")
    # end
  end
end
