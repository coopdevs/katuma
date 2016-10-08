user = ::Account::User.create(
  email: 'joanin@katuma.org',
  first_name: 'Joanin',
  last_name: 'Cerea',
  username: 'joanin',
  password: 'kakaka22'
)

group = ::BasicResources::Group.create(
  name: 'Tomatika'
)

::BasicResources::Membership.create(
  user_id: user.id,
  basic_resource_group_id: group.id,
  role: ::BasicResources::Membership::ROLES[:admin]
)
