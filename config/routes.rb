# Rails.application.routes.draw do
#   devise_for :users, controllers: {
#     registrations: 'users/registrations'
#   }
#   devise_for :admin_users, ActiveAdmin::Devise.config
#   ActiveAdmin.routes(self)

#   root 'home#index'

#   get '/about', to: 'static_pages#show', slug: 'about'
#   get '/contact', to: 'contact#show'
#   resources :categories, only: [:index, :show]
#   resources :products, only: [:index, :show]
#   resources :orders, only: [:new, :create, :show] do
#     collection do
#       get 'past_orders'
#     end
#     member do
#       get 'invoice'
#       patch 'update_item/:item_id', to: 'orders#update_item', as: 'update_item'
#       delete 'remove_item/:item_id', to: 'orders#remove_item', as: 'remove_item'
#       post 'add_item', to: 'orders#add_item'
#       post 'checkout', to: 'orders#checkout'
#     end
#   end

#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'home#index'

  get '/about', to: 'static_pages#show', slug: 'about'
  get '/contact', to: 'contact#show'
  resources :categories, only: [:index, :show]
  resources :products, only: [:index, :show]
  resources :orders, only: [:new, :create, :show, :destroy] do
    collection do
      get 'past_orders'
    end
    member do
      get 'invoice'
      post 'checkout'
      post 'confirm'
      patch 'update_item/:item_id', to: 'orders#update_item', as: 'update_item'
      delete 'remove_item/:item_id', to: 'orders#remove_item', as: 'remove_item'
      post 'add_item', to: 'orders#add_item', as: 'add_item'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
