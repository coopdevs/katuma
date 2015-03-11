Katuma::Application.routes.draw do

  mount Account::Engine,    at: '/'
  mount Landing::Engine,    at: '/'
end
