BasicResources::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :memberships, except: [:new, :edit]
      resources :groups, except: [:new, :edit]
      resources :producers, only: [:create, :update, :destroy]
      resources :users, only: [:index]
    end
  end
end
