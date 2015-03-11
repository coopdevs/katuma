Account::Engine.routes.draw do

  get  'login',  to: 'session#login'
  post 'login',  to: 'session#login_attempt'
  get  'logout', to: 'session#logout'
  get  'signup', to: 'signup#new'
  post 'signup', to: 'signup#create'
  get  'signups/:id/complete', to: 'signup#complete', as: 'complete_signup'
  post 'signups/:id/complete', to: 'signup#create_user'
  get  'complete_confirmed', to: 'signup#complete_from_confirmed_email', as: 'complete_from_confirmed_email'

  namespace :api do
    namespace :v1 do
      get :account, controller: :users, action: :account
      resources :users, except: [:new, :edit]
    end
  end
end
