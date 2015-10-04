Account::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signups', to: 'signups#create'
      get '/signups/:token', to: 'signups#show'
      post :login, controller: :login, action: :login
      post '/users', to: 'users#create'
    end
  end
end
