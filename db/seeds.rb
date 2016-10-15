# Users

joanin = ::Account::User.create!(
  email: 'joanin@katuma.org',
  first_name: 'Joanin',
  last_name: 'Cerea',
  username: 'joanin',
  password: 'papapa22'
)

frida = ::Account::User.create!(
  email: 'frida@katuma.org',
  first_name: 'Frida',
  last_name: 'Fola',
  username: 'frida',
  password: 'papapa22'
)

# Groups

tomatika = ::BasicResources::Group.create!(
  name: 'Tomatika'
)

::BasicResources::Membership.create!(
  user_id: joanin.id,
  basic_resource_group_id: tomatika.id,
  role: ::BasicResources::Membership::ROLES[:admin]
)

::BasicResources::Membership.create!(
  user_id: frida.id,
  basic_resource_group_id: tomatika.id,
  role: ::BasicResources::Membership::ROLES[:member]
)

cabas = ::BasicResources::Group.create!(
  name: 'Cabas'
)

::BasicResources::Membership.create!(
  user_id: frida.id,
  basic_resource_group_id: cabas.id,
  role: ::BasicResources::Membership::ROLES[:admin]
)

# Producers

jaume = ::BasicResources::Producer.new(
  name: 'El Jaume',
  email: 'jaume@eljaume.coop',
  address: 'c/ de les peras, 33, Barbera del Valles'
)
::BasicResources::ProducerCreator.new(
  producer: jaume,
  creator: joanin,
  group: tomatika
).create!
::Suppliers::Supplier.create!(
  group_id: tomatika.id,
  producer_id: jaume.id
)

prueba = ::BasicResources::Producer.new(
  name: 'Productor de prueba',
  email: 'test@katuma.org',
  address: 'c/ de las pruebas, Barcelona'
)
::BasicResources::ProducerCreator.new(
  producer: prueba,
  creator: joanin,
  group: tomatika
).create!
