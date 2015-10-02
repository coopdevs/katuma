Account::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signups', to: 'signups#create'
      get '/signups/:token', to: 'signups#show'
      get '/me', to: 'me#show'
      post :login, controller: :session, action: :login
      get :logout, controller: :session, action: :logout
      post '/users', to: 'users#create'
    end
  end
end
