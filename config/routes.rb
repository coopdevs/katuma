Katuma::Application.routes.draw do

  use_doorkeeper

  mount Landing::Engine,    at: '/'
  mount Account::Engine,    at: '/'
  mount Landing::Engine,    at: '/'
end
