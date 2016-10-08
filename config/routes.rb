Katuma::Application.routes.draw do
  mount Account::Engine,        at: '/'
  mount BasicResources::Engine, at: '/'
  mount Onboarding::Engine,     at: '/'
  mount Products::Engine,       at: '/'
  mount Suppliers::Engine,      at: '/'
end
