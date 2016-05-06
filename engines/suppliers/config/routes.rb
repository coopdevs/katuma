Suppliers::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :suppliers, except: [:new, :edit]
    end
  end
end
