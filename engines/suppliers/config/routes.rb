Suppliers::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :suppliers, except: [:new, :edit]
      resources :producers, only: [:index, :show]
      resources :products, only: [:index]
      resources :orders_frequencies, except: [:new, :edit, :destroy]
      resources :orders, except: [:new, :edit]
      resources :order_lines, only: [:index, :create, :update, :destroy]
    end
  end
end
