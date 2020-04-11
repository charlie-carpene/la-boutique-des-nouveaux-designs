Rails.application.routes.draw do
  root 'static_pages#index'
  devise_for :users

  resources :users, only: [:show]
  resources :addresses, only: [:new, :create, :show, :edit, :destroy]
end
