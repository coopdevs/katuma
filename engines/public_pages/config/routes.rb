PublicPages::Engine.routes.draw do
  root to: 'landing#main'

  get  'login',  to: 'session#login'
  post 'login',  to: 'session#login_attempt'
  get  'logout', to: 'session#logout'
  get  'signup', to: 'onboarding#signup'
  post 'signup', to: 'onboarding#create_user'
end
