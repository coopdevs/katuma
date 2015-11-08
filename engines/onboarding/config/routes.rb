Onboarding::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'invitations/bulk', controller: 'invitations', action: :bulk
      get 'invitations/:token', to: 'invitations#show'
      post 'invitations/accept/:token', to: 'invitations#accept'
    end
  end
end
