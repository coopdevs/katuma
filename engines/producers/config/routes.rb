Producers::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :producers, except: [:new, :edit]
      resources :products, except: [:new, :edit]
    end
  end
end
