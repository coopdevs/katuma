PublicPages::Engine.routes.draw do
  root to: 'landing#main'

  get 'login', to: 'session#login'
  get 'logout', to: 'session#logout'
  post 'login_attempt', to: 'session#login_attempt'
  get 'signup', to: 'onboarding#signup'
  post 'create_user', to: 'onboarding#create_user'
end
