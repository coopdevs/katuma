Katuma::Application.routes.draw do

  mount Landing::Engine,    at: '/'
  mount Account::Engine,    at: '/'
  mount Group::Engine,      at: '/'
  mount Onboarding::Engine, at: '/'
end
