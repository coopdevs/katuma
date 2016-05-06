user = ::Account::User.create!(
  email: 'joanin@katuma.org',
  first_name: 'Joanin',
  last_name: 'Cerea',
  username: 'joanin',
  password: 'kakaka22'
)

group = ::Group::Group.create!(
  name: 'Tomatika'
)

::Group::Membership.create!(
  user: ::Group::User.find(user.id),
  group: group,
  role: ::Group::Membership::ROLES[:admin]
)

producer = ::Producers::Producer.create!(
  name: 'Joan Pipa',
  email: 'joan.pipa@katuma.org',
  address: 'pl. Catalunya 1'
)

producer = Suppliers::Producer.find_by_id(producer.id)
group = Suppliers::Group.find_by_id(group.id)

Suppliers::Supplier.create!(
  producer: producer,
  group: group
)
