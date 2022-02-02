Rails.application.routes.draw do
  
  resources :poll_answers

  resources :polls, shallow: true do
    resources :poll_questions
  end
  
  #Authentication
  get '/homepage', to: 'application#account', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  #FormVoting
  get '/polls/:invite_token/form', to: 'polls#form', as: 'form'
  post '/polls/:invite_token/submit', to: 'poll_votes#submit', as: 'poll_submit'
  get '/polls/:invite_token/qr_code', to: 'poll_votes#qr', as: 'form_qr'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#welcome'
  # Defines the root path route ("/")
  #root "articles#index"
end
