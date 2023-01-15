Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "pages#index"

  get "about", to: "pages#about"
  # Below we are explicitly exposing the routes we want to use
  # resources :posts, only: [ :show, :index, :create, :new, :edit, :update, :destroy ]

  # To expose all the RESTful endpionts by default
  resources :posts

  get "signup", to: "users#new"
  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
