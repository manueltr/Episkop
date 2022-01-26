Rails.application.routes.draw do
  resources :poll_questions
  resources :polls
  
  #Authentication
  get '/homepage', to: 'application#account', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#welcome'
  # Defines the root path route ("/")
  #root "articles#index"
end
