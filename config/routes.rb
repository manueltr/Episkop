Rails.application.routes.draw do
  
  resources :poll_answers

  resources :polls, shallow: true do
    resources :poll_questions
  end
  
  resources :directories, only: [:show, :create]
   
  # email invitations
  get '/pollsinvite/sendinvite', to: 'polls#send_email_invite', as: 'send_email_invite'

  #Authentication
  get '/homepage', to: 'application#account', as: 'logged_in'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  #Directory
  get '/application/directory', to: 'application#directory', as: 'directory_home'

  #FormVoting
  get '/polls/:invite_token/form', to: 'polls#form', as: 'form'
  post '/polls/:invite_token/submit', to: 'poll_votes#submit', as: 'poll_submit'
  get '/polls/:invite_token/qr_code', to: 'poll_votes#qr', as: 'form_qr'


  # API routes
  get '/polls_api', to: 'api#index', as: 'polls_api_index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#welcome'
  # Defines the root path route ("/")
  #root "articles#index"



  
end
