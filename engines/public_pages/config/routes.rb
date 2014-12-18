PublicPages::Engine.routes.draw do
  root to: 'landing#main'

  get 'login', to: 'session#login'
  get 'logout', to: 'session#logout'
  post 'login_attempt', to: 'session#login_attempt'
end
