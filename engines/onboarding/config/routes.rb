Onboarding::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'invitations/bulk', controller: 'invitations', action: :bulk
      post 'invitations/accept/:token', controller: 'invitations', action: :accept
    end
  end
end
