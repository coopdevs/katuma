Katuma::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      # ToDo: remove this and put bootstrap data
      # in dashboard index HTML
      get :bootstrap, controller: :users, action: :bootstrap
      post :session, controller: :sessions, action: :create
      resources :users, except: [:new, :edit, :index]
      resources :groups, except: [:new, :edit] do
        resources :waiting_users, controller: :waiting_users, only: [:index, :create, :destroy]
        resources :users_units, except: [:new, :edit], shallow: true do
          get :users, controller: :users, action: :index
        end
      end
    end
  end

end
