require 'ice_cube'

# Users
puts 'Creating users...'

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
puts 'Creating groups...'

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
puts 'Creating producers...'

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

# Products
puts 'Creating products...'

poma = ::Products::Product.create!(
  producer_id: jaume.id,
  name: 'Poma fuji',
  unit: ::Products::Product::UNITS[:kg],
  price: 2.99
)
::Products::Product.create!(
  producer_id: jaume.id,
  name: 'Bledas al manat',
  unit: ::Products::Product::UNITS[:pc],
  price: 1.85
)

# OrdersFrequencies
puts 'Creating order_frequencies...'

confirmation_schedule = IceCube::Schedule.new do |f|
  f.add_recurrence_rule IceCube::Rule.weekly.day(:saturday)
end
::Suppliers::OrdersFrequency.create!(
  group_id: tomatika.id,
  ical: confirmation_schedule.to_ical,
  frequency_type: ::Suppliers::OrdersFrequency::FREQUENCY_TYPES[:confirmation]
)

delivery_schedule = IceCube::Schedule.new do |f|
  f.add_recurrence_rule IceCube::Rule.weekly.day(:wednesday)
end
::Suppliers::OrdersFrequency.create!(
  group_id: tomatika.id,
  ical: delivery_schedule.to_ical,
  frequency_type: ::Suppliers::OrdersFrequency::FREQUENCY_TYPES[:delivery]
)

# Orders
puts 'Creating orders...'

first_order = ::Suppliers::Order.create!(
  from_user_id: joanin.id,
  to_group_id: tomatika.id,
  confirm_before: 2.days.ago.utc
)
::Suppliers::Order.create!(
  from_user_id: frida.id,
  to_group_id: tomatika.id,
  confirm_before: 2.days.ago.utc
)
::Suppliers::Order.create!(
  from_user_id: frida.id,
  to_group_id: cabas.id,
  confirm_before: 3.days.ago.utc
)

# Order lines
puts 'Creating order lines...'

::Suppliers::OrderLine.create!(
  order: first_order,
  product_id: poma.id,
  price: 2.57,
  quantity: 1
)
