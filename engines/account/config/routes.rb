Account::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signups', to: 'signups#create'
      get '/signups/:token', to: 'signups#show'
      post '/signups/complete/:token', to: 'signups#complete'
      get '/me', to: 'me#show'
      post :login, controller: :login, action: :login
    end
  end
end
