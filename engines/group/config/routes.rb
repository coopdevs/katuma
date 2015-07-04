Group::Engine.routes.draw do

  get '/dashboard', to: 'groups#index'
  resources :groups, except: [:index, :edit] do
    member do
      get 'settings'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :memberships, except: [:new, :edit]
      resources :groups, except: [:new, :edit]
    end
  end
end
