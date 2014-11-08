Katuma::Application.routes.draw do

  mount PublicPages::Engine, at: '/'

  namespace :api do
    namespace :v1 do
      post :sessions, controller: :sessions, action: :create
      delete :sessions, controller: :sessions, action: :destroy
      get :account, controller: :users, action: :account
      resources :memberships
      resources :users, except: [:new, :edit]
      resources :groups, except: [:new, :edit] do
        resources :users_units, except: [:new, :edit], shallow: true do
        end
      end
      resources :invitations, except: [:new, :edit] do
        member do
          put :accept
        end
      end
    end
  end
end
