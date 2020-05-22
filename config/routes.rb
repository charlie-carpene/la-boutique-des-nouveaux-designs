Rails.application.routes.draw do
  root 'static_pages#index'
  get "become_maker" => 'static_pages#become_maker'

  devise_for :users

  resources :users, only: [:show, :edit, :update] do
    resources :addresses, only: [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :categories, only: [:show]
  resources :shops
  resources :shop_images, only: [:show, :edit, :update]
  resources :items
  resources :carts, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

end
