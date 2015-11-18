Katuma::Application.routes.draw do
  mount Account::Engine,    at: '/'
  mount Group::Engine,      at: '/'
  mount Onboarding::Engine, at: '/'
end
