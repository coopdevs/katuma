Onboarding::Engine.routes.draw do

  resources :users, only: [] do
    member do
      resources :invitations, only: [:accept] do
        get :accept, controller: 'invitations', action: :accept, on: :member
      end
    end
  end

  namespace :api do
    namespace :v1 do
      post :invitations, controller: 'invitations', action: :create
    end
  end
end
