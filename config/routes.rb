Katuma::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: [:new, :edit]
      resources :groups, except: [:new, :edit] do
        resources :waiting_list, controller: :waiting_list_memberships, only: [:index, :create, :destroy]
        resources :users_units, except: [:new, :edit]
      end
    end
  end
end
