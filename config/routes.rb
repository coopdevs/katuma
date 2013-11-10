Katuma::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      #resources :users, except: [:new, :edit]
      #resources :customers, except: [:new, :edit] do
        #resource :waiting_list, except: [:new, :edit, :update]
      #end
      resources :waiting_lists, only: [:show, :update], shallow: true do
        resources :users, only: [:index]
      end

        #resources :users_units, except: [:new, :edit]
    end
  end

end
