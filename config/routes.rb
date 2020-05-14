Rails.application.routes.draw do
  get 'shop_images/show'
  root 'static_pages#index'
  get "become_maker" => 'static_pages#become_maker'

  devise_for :users

  resources :users, only: [:show, :edit, :update] do
    resources :addresses, only: [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :categories, only: [:show]
  resources :shops, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :shop_images, only: [:show]

end
