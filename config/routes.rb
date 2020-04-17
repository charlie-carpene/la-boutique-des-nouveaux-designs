Rails.application.routes.draw do
  root 'static_pages#index'
  devise_for :users

  resources :users, only: [:show] do
    resources :addresses, only: [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :categories, only: [:show]

end
