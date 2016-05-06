Rails.application.routes.draw do
  #get 'users/index'
  devise_for :admins
  resources :orders
  resources :line_items
  resources :carts
  resources :categories
  get 'pages/delivery'

  get 'pages/waranty'

  resources :listings do
    collection do
      get 'search'
    end
  end

  devise_for :users
  resources :listings
  resources :posts
  get 'pages/about'

  get 'pages/contact'

  get 'posts/index'

  root 'listings#index'

  match '/users',   to: 'users#index',   via: 'get'
end
