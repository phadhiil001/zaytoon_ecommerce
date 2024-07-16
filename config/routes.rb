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
  resources :orders, only: [:new, :create, :show]

  resource :order, only: [:show] do
    post 'add_item', to: 'orders#add_item'
    patch 'update_item/:id', to: 'orders#update_item', as: 'update_item'
    delete 'remove_item/:id', to: 'orders#remove_item', as: 'remove_item'
    get 'invoice', to: 'orders#invoice'
    post 'checkout', to: 'orders#checkout'
    get 'confirm', to: 'orders#confirm'
  end
end
