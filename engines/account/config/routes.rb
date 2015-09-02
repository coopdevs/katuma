Account::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post :signups, controller: :signups, action: :create
      post :login, controller: :login, action: :login
    end
  end
end
