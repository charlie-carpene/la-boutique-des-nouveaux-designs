Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get 'orders/new'
  root 'static_pages#index'
  get "become_maker" => 'static_pages#become_maker'
  get "cgv" => 'static_pages#cgv'
  get "stripe_fallback" => 'static_pages#stripe_fallback'

  match "404", to: "errors#not_found", via: :all
  match "500", to: "errors#internal_server_error", via: :all

  devise_for :users

  devise_for :shops, controllers: {
    omniauth_callbacks: 'shops/omniauth_callbacks'
  }

  resources :users, only: [:show, :edit, :update] do
    resources :addresses, only: [:new, :create, :show, :edit, :update, :destroy]
    resources :orders, only: [:index, :show]
  end

  resources :categories, only: [:show]
  resources :shops
  resources :shop_images, only: [:show, :edit, :update]
  resources :items
  resources :carts, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]
  resources :orders, only: [:new, :create]
  resources :order_items, only: [:index]
end
