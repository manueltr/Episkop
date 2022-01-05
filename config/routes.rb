Rails.application.routes.draw do
  
  #Authentication
  get '/login', to: 'application#welcome', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'


  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  # Defines the root path route ("/")
  #root "articles#index"
end
