Katuma::Application.routes.draw do


  namespace :api do
    namespace :v1 do
      post :sessions, controller: :sessions, action: :create
      delete :sessions, controller: :sessions, action: :destroy
      get :account, controller: :users, action: :account
      resources :memberships
      resources :users, except: [:new, :edit, :index]
      resources :groups, except: [:new, :edit] do
        resources :users_units, except: [:new, :edit], shallow: true do
          get :users, controller: :users, action: :index
        end
      end
    end
  end

end
