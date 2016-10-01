Katuma::Application.routes.draw do
  mount Account::Engine,        at: '/'
  mount BasicResources::Engine, at: '/'
  mount Onboarding::Engine,     at: '/'
  mount Producers::Engine,      at: '/'
  mount Suppliers::Engine,      at: '/'
end
