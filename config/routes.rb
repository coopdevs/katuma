Katuma::Application.routes.draw do


  namespace :api do
    namespace :v1 do
      # ToDo: remove this and put bootstrap data
      # in dashboard index HTML
      get :bootstrap, controller: :users, action: :bootstrap
      post :sessions, controller: :sessions, action: :create
      delete :sessions, controller: :sessions, action: :destroy
      resources :users, except: [:new, :edit, :index] do
        resources :memberships
      end
      resources :groups, except: [:new, :edit] do
        resources :users_units, except: [:new, :edit], shallow: true do
          get :users, controller: :users, action: :index
        end
      end
    end
  end

end
