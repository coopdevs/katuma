Products::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, except: [:new, :edit, :index]
    end
  end
end
