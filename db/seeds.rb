user = ::Account::User.create(
  email: 'joanin@katuma.org',
  first_name: 'Joanin',
  last_name: 'Cerea',
  username: 'joanin',
  password: 'kakaka22'
)

group = ::Group::Group.create(
  name: 'Tomatika'
)

::Group::Membership.create(
  user: ::Group::User.find(user.id),
  group: group,
  role: ::Group::Membership::ROLES[:admin]
)

Suppliers::Supplier.create(
  group: group
)
